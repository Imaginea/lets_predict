class UsersController < ApplicationController
  before_filter :restrict_to_my_account, :only => [:show]
  before_filter :restrict_to_open_tournaments, :only => [:leaderboard]

  def show
    @new_tournament = Tournament.current_tournaments
    @prediction = Prediction.new
    @predicted_teams = current_user.predicted_teams_by_match_id
    @teams = Team.all
  end
  
  def leaderboard
    @prediction = Prediction.new
    @predicted_teams = current_user.predicted_teams_by_match_id
    @teams = Team.all
  end

  private

  def restrict_to_my_account
    access_denied if params[:id]
  end
end
