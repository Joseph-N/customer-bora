class ContactMailer < ActionMailer::Base

  def send_email(name, email, message)
    @name= name
    @message = message
    mail(to: ENV["EMAIL"], from: email, subject: "#{name} Contacted Customer Bora")
  end
end
