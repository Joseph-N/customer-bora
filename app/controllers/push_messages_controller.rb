class PushMessagesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    mappings = {"id" => "aftk_id", "text" => "message", "from" => "from", "to" => "to", "linkId" => "aftk_linkid",
                "date" => "sent_at"}

    push_messages_params = Hash[push_params.map {|k, v| [mappings[k], v] }]

    push_msg = PushMessage.create!(push_messages_params)

    contents =  push_msg.message.split('#')
    multiple_submissions = push_msg.message.split(',')

    validate_message(contents, push_msg)

    if multiple_submissions.size >= 2
      multiple_submissions.each do |submission|
        validate_message(submission.split('#'), push_msg)
      end
    end

    render text: "success"
  end


  private

  def validate_message(contents, push_msg)
    if contents.size == 1 and contents.first.downcase.strip == "stop"
      unsuscribe_user(push_msg.from, push_msg.aftk_linkid)
    elsif contents.size > 1 and contents.size <= 2
      process_message(contents, push_msg)
    else
      # send unprocessed sms
      message = I18n.t('sms.failure.unprocessable_message', short_code: ENV['SHORT_CODE'])
      $smsGateway.send_message(push_msg.from, message, ENV['SHORT_CODE'], 0, {:linkId => push_msg.aftk_linkid})
      # push_msg.destroy
    end
  end

  def process_message(contents, push_msg)
    case contents.first.downcase.strip
      when "register"
        user_from_sms(contents.last.titleize, push_msg.from, push_msg.aftk_linkid)
      when "location"
        location_from_sms(contents.last.titleize, push_msg.from, push_msg.aftk_linkid)
      else
        product_from_sms(contents.first, contents.last, push_msg.from, push_msg.aftk_linkid)
    end
  end

  def user_from_sms(name, phone, link_id)
    password = (0..5).map { ('a'..'z').to_a[rand(26)] }.join

    user = User.new(name: name, phone: phone,
                    email: "cust-bora-#{(0...5).map { ('a'..'z').to_a[rand(26)] }.join}@gmail.com",
                    password: password,password_confirmation: password)
    if user.save
      message = I18n.t('sms.registration.success', user: user.name, password: password)
      $smsGateway.send_message(phone, message, ENV['SHORT_CODE'],0, {:linkId => link_id})
    else
      message = I18n.t('sms.registration.failure', errors: user.errors.full_messages.join(','))
      $smsGateway.send_message(phone, message, ENV['SHORT_CODE'],0, {:linkId => link_id})
    end
  end

  def product_from_sms(brand,serial,phone_no, link_id)
    user = User.find_by phone: phone_no
    if user
      submission = user.submissions.new(:name => brand, :serial_no => serial)
      if submission.save
        message = I18n.t('sms.submission.success', count: user.submissions.count * 5)
        $smsGateway.send_message(phone_no, message, ENV['SHORT_CODE'],0, {:linkId => link_id})
      else
        message = I18n.t('sms.submission.failure', errors: submission.errors.full_messages.join(','))
        $smsGateway.send_message(phone_no, message, ENV['SHORT_CODE'],0, {:linkId => link_id})
      end

    else
      message = I18n.t('sms.submission.unregistered', short_code: ENV['SHORT_CODE'])
      $smsGateway.send_message(phone_no, message, ENV['SHORT_CODE'],0, {:linkId => link_id})
    end

  end

  def location_from_sms(location, phone_no, link_id)
    user = User.find_by phone: phone_no
    if user
      if user.update_attribute(:location,location)
        message = I18n.t('sms.location.success', location: location)
        $smsGateway.send_message(phone_no, message, ENV['SHORT_CODE'],0, {:linkId => link_id})
      else
        message = I18n.t('sms.location.failure', errors: user.errors.full_messages.join(','))
        $smsGateway.send_message(phone_no, message, ENV['SHORT_CODE'],0, {:linkId => link_id})
      end
    else
      message =  I18n.t('sms.location.unregistered', short_code: ENV['SHORT_CODE'])
      $smsGateway.send_message(phone_no, message, ENV['SHORT_CODE'],0, {:linkId => link_id})
    end

  end

  def unsuscribe_user(phone_no, link_id)
    user = User.find_by phone: phone_no
    if user
      message = I18n.t('sms.unsuscribe.success')
      $smsGateway.send_message(phone_no, message, ENV['SHORT_CODE'],0, {:linkId => link_id}) if user.unsuscribe
    else
      message = I18n.t('sms.unsuscribe.failure')
      $smsGateway.send_message(phone_no, message, ENV['SHORT_CODE'],0, {:linkId => link_id})
    end
  end

  def push_params
    params.permit(:id, :text, :from, :to, :linkId, :date)
  end
end
