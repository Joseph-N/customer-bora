class UsersController < ApplicationController
  before_filter :correct_user unless :admin_signed_in?

  def show
    @user  = User.find(params[:id])
  end

  private
  def correct_user
    user = User.find(params[:id])
    unless user == current_user
      redirect_to root_path, :gflash => {:error => {:title => "Permission Denied",
                                                    :value => "You dont't have permission to access the specified url"
      }}
    end
  end

  def is_admin?
    current_user.admin?
  end
end
