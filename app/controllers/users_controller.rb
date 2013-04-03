class UsersController < ApplicationController
  before_filter :restrict_to_my_account, :only => [:show]
  before_filter :restrict_to_open_tournaments, :only => [:leaderboard]

  def show
    @new_tournament = Tournament.current_tournaments
  end
  
  def leaderboard   
  end

  private

  def restrict_to_my_account
    access_denied if params[:id]
  end
end
