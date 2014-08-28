class DashboardController < ApplicationController
  before_action :verify_admin

  def index
    @suscribed_users = User.suscribed.count
    @unsuscribed_users = User.count - @suscribed_users
    @submission_count = Submission.count
    @faq_count = Faq.count

    @users = User.limit(15).order("created_at DESC")
    @submissions = Submission.limit(10).order("created_at DESC")
    generate_js
  end

  def custom_sms
    if params[:custom_numbers].present? && params[:custom_message].present?
      $smsGateway.send_message(params[:custom_numbers],params[:custom_message], ENV["SHORT_CODE"])
      redirect_to dashboard_index_path, notice: "Successfully sent messages"
    else
      redirect_to dashboard_index_path, alert: "Message or Phone Numbers cannot be blank"
    end
  end

  def sms
    if params[:users].present? && params[:phone_numbers].present?
      redirect_to dashboard_index_path, alert: "Dont fill in phone numbers and use checkboxes"
    else
      if params[:phone_numbers] && !params[:users].present? && !params[:message].blank? && !params[:phone_numbers].blank?
        recipients = params[:phone_numbers]
        $smsGateway.send_message(recipients, params[:message], ENV['SHORT_CODE'])
        redirect_to dashboard_index_path, notice: "Successfully sent messages to #{recipients.split(',').size} users"
      elsif params[:users] == "all_users" && !params[:message].blank?
        recipients = User.suscribed.map(&:phone).join(",")

        $smsGateway.send_message(recipients, params[:message], ENV['SHORT_CODE'])
        redirect_to dashboard_index_path, notice: "Successfully sent messages to #{recipients.split(',').size} users"
      elsif params[:users] == "only_location" && !params[:message].blank?
        recipients = User.suscribed.where.not(:location => nil).map(&:phone).join(",")

        $smsGateway.send_message(recipients, params[:message], ENV['SHORT_CODE'])
        redirect_to dashboard_index_path, notice: "Successfully sent messages to #{recipients.split(',').size} users"
      elsif params[:users] == "only_submission" && !params[:message].blank?
        recipients = User.suscribed.where.not(:submissions_count => nil).map(&:phone)

        Thread.new{
          recipients.each do |recipient|
            $smsGateway.send_message(recipient, params[:message], ENV['SHORT_CODE'])
          end
        }
        redirect_to dashboard_index_path, notice: "Successfully sent messages to #{recipients.split(',').size} users"
      elsif params[:users] == "past_week_submission" && !params[:message].blank?
        uniq_ids = Submission.where("created_at >= ?",7.days.ago).map(&:user_id).uniq
        recipients = User.suscribed.where(:id => uniq_ids).map(&:phone).join(",")

        $smsGateway.send_message(recipients, params[:message], ENV['SHORT_CODE'])
        redirect_to dashboard_index_path, notice: "Successfully sent messages to #{recipients.split(',').size} users"
      else
        redirect_to dashboard_index_path, alert: "Ensure message is not blank"
      end
    end
  end

  private
  def verify_admin
      redirect_to root_path, alert: "Access denied" unless admin_signed_in?
  end

  def generate_js
    token_data = []
    User.find_each do |user|
      data = {}
      data[:id] = user.phone
      data[:phone] = user.name ? "#{user.name}  #{user.phone}" : user.phone
      token_data << data
    end

    file = Rails.root.join("public", "autocomplete-data", "customers.js")
    File.open(file, 'w') { |f| f.write("data = " + token_data.to_json) }
  end
end
