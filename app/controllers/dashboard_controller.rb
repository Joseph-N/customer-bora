class DashboardController < ApplicationController
  before_action :verify_admin

  def index
    @user_count = User.count
    @submission_count = Submission.count
    @faq_count = Faq.count

    @users = User.limit(10).order("created_at DESC")
  end

  def sms
    if params[:all_users]
      recipients = User.all.map(&:phone).join(",")

      $smsGateway.send_message(recipients, params[:message], ENV['SHORT_CODE'])
      redirect_to dashboard_index_path, notice: "Successfully sent messages to #{recipients.split(',').size} users"
    elsif params[:only_location]
      recipients = User.where.not(:location => nil).map(&:phone).join(",")

      $smsGateway.send_message(recipients, params[:message], ENV['SHORT_CODE'])
      redirect_to dashboard_index_path, notice: "Successfully sent messages to #{recipients.split(',').size} users"
    elsif params[:only_submission]
      recipients = User.where.not(:submissions_count => nil).map(&:phone).join(",")

      $smsGateway.send_message(recipients, params[:message], ENV['SHORT_CODE'])
      redirect_to dashboard_index_path, notice: "Successfully sent messages to #{recipients.split(',').size} users"
    else
      redirect_to dashboard_index_path, alert: "Unknown request"
    end
  end

  private
  def verify_admin
      redirect_to root_path, alert: "Access denied" unless admin_signed_in?
  end
end
