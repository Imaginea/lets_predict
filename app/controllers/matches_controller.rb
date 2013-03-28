class MatchesController < ApplicationController
  def statistics
    #@user = current_user
    @current_tournament = Tournament.find(params[:tournament_id])
    @prediction = Prediction.new
    @predicted_teams = current_user.predicted_teams_by_match_id
    @teams = Team.all
  end
end
