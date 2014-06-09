require 'csv'

namespace :customers do
  desc "Import Pre-Existing customers "
  task :import => :environment do
    p "Importing users"
    CSV.foreach("data/default_cb_customer.csv") do  |row|
      name = row[1].strip.titleize unless row[1].nil?
      phone = row[2]

      chars =  (0..9).to_a << ('a'..'z').to_a
      password = (0..5).map { chars.flatten[rand(35)] }.join

      user = User.new(name: name, phone: phone, email: "cust-bora-#{(0...7).map { ('a'..'z').to_a[rand(26)] }.join}@gmail.com",
                          password: password,password_confirmation: password)
      if user.save
        message = "Hello customerbora, login to your online a/c with password: #{password}.Provide your location for collection purposes by replying to this sms with LOCATION#YOURAREA"
        p "saved #{user.name}"
        # $smsGateway.send_message(user.phone, message, ENV['SHORT_CODE'])
      else
        p "User could not be created due to: #{user.errors.full_messages.join(',')}"
      end
    end
  end
end

