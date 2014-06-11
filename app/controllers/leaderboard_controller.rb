class LeaderboardController < ApplicationController
  def index
    @users = User.order('submissions_count DESC').limit(20)
  end
end
