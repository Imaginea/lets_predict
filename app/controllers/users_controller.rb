class UsersController < ApplicationController

  def show
    #@user = current_user
    @new_tournament = Tournament.current_tournaments
    @prediction = Prediction.new
    @predicted_teams = current_user.predicted_teams_by_match_id
    @teams = Team.all
  end
  
  def index
    @users = User.all
  end

  def leaderboard
    @prediction = Prediction.new
    @predicted_teams = current_user.predicted_teams_by_match_id
    @teams = Team.all
    @current_tournament =  Tournament.find(params[:tournament_id])

  end

end