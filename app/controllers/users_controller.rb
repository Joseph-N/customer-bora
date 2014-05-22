class UsersController < ApplicationController
  before_filter :set_user
  before_filter :correct_user

  def show
  end

  private
  def set_user
    @user  = User.find(params[:id])
  end

  private
  def correct_user
    unless @user == current_user
      redirect_to root_path, :gflash => {:error => {:title => "Permission Denied",
                                                    :value => "You dont't have permission to access the specified url"
      }}
    end
  end
end
