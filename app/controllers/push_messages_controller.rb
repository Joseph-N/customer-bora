class PushMessagesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    mappings = {"id" => "aftk_id", "text" => "message", "from" => "from", "to" => "to", "linkId" => "aftk_linkid",
                "date" => "sent_at"}
    push_messages_params = Hash[push_params.map {|k, v| [mappings[k], v] }]

    push_msg = PushMessage.create!(push_messages_params)
    contents =  push_msg.message.split('#')
    if contents.size > 1 and contents.size <= 2
      if contents.first.downcase == "register"
        user_from_sms(contents.last, push_msg.from)
      else
        product_from_sms(contents.first, contents.last, push_msg.from)
      end
    else
      #  send unprocessed sms
      message = "There was an error processing your message. Please try again\r\nTo register: send register#YOUR NAME to #{ENV['SHORT_CODE']}\r\nTo submit: send productName#productSerialNo to #{ENV['SHORT_CODE']}"
      push_msg.destroy

      $smsGateway.send_message(push_msg.from, message, ENV['SHORT_CODE'])
    end

    render text: "success"
  end

  private

  def user_from_sms(name, phone)
    password = (0...7).map { ('a'..'z').to_a[rand(26)] }.join

    user = User.new(name: name, phone: phone,
                    email: "cust-bora-#{(0...5).map { ('a'..'z').to_a[rand(26)] }.join}@gmail.com",
                    password: password,password_confirmation: password)
    if user.save
      message = "Hi #{user.name}, your CustomerBora account was successfully created. Your password is #{password}"
      $smsGateway.send_message(phone, message, ENV['SHORT_CODE'])
    else
      errors = user.errors.full_messages
      message = "Your account could not be created. Reason: #{errors.join(',')}"
      $smsGateway.send_message(phone, message, ENV['SHORT_CODE'])
    end
  end

  def product_from_sms(brand,serial,phone_no)
    user = User.find_by phone: phone_no
    if user
      submission = user.submissions.new(:name => brand, :serial_no => serial)
      if submission.save
        message = "Thank you, your submission was successfully recorded.\r\nSubmissions to date: #{user.submissions.count}"
        $smsGateway.send_message(phone_no, message, ENV['SHORT_CODE'])
      else
        errors = submission.errors.full_messages
        message = "Ooops, there was a problem with your submission. Reason: #{errors.join(',')}"
        $smsGateway.send_message(phone_no, message, ENV['SHORT_CODE'])
      end

    else
      message = "It seems you are not registered yet. To start submitting products, send register#YOUR NAME to #{ENV['SHORT_CODE']}"
      $smsGateway.send_message(phone_no, message, ENV['SHORT_CODE'])
    end

  end

  def push_params
    params.permit(:id, :text, :from, :to, :linkId, :date)
  end
end
