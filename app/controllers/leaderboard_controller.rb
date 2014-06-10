class LeaderboardController < ApplicationController
  def index
    @users = User.includes(:submissions).sample(10)
  end
end
