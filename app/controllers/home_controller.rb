class HomeController < ApplicationController
  def index
  end

  def contact

    unless /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.match(contact_params[:email]).nil?
      ContactMailer.send_email(contact_params[:name],
                               contact_params[:email],
                               contact_params[:message]).deliver!

      gflash :success => "Thanks for contacting Us. Will get in touch soon!"
      redirect_to root_path
    else
      flash[:alert] = "Oops! the email specified does not look correct"
      gflash :error => "Oops! the email specified does not look correct"
      render 'index'
    end

  end

  def sms
    render json: params
  end

  private

  def contact_params
    params.permit(:name, :email, :message, :utf8, :authenticity_token, :commit)
  end
end
