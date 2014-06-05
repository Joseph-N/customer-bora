require 'csv'

namespace :customers do
  desc "Import Pre-Existing customers "
  task :import => :environment do
    p "Importing users"
    CSV.foreach("data/default_cb_customer.csv") do  |row|
      name = row[1].titleize unless row[1].nil?
      phone = row[2]

      password = (0...7).map { ('a'..'z').to_a[rand(26)] }.join

      user = User.new(name: name, phone: phone, email: "cust-bora-#{(0...5).map { ('a'..'z').to_a[rand(26)] }.join}@gmail.com",
                          password: password,password_confirmation: password)
      if user.save
        message = "Hi #{user.name}, we've just set up your customerbora profile. Log in at customerbora.com with your phone number and password: #{password} and update your profile"
        # $smsGateway.send_message(user.phone, message,ENV['SHORT_CODE'])
      end
    end
  end
end

