class MatchesController < ApplicationController
  before_filter :restrict_to_open_tournaments, :only => [:statistics]
  before_filter :restrict_to_admins, :only => [:update, :update_results]

  def update
    match = Match.find(params[:id])
    match.update_attribute(:winner_id, params[:winner_id])
    redirect_to(:back) and return if match.no_result?

    pred_scope = Prediction.where(:match_id => match.id, :predicted_team_id => match.winner_id)
    res = pred_scope.update_all(:points => match.success_points)
    msg = "Updated #{res} correct predictions with #{match.success_points} points"

    pred_scope = Prediction.where(:match_id => match.id).where("predicted_team_id IS NOT NULL AND predicted_team_id <> #{match.winner_id}")
    res = pred_scope.update_all(:points => match.failure_points)
    msg << " and #{res} wrong predictions with #{match.failure_points} points"

    redirect_to :back, :notice => msg
  end

  def update_results
    t = Tournament.find(params[:tournament_id])
    @teams = t.teams
    @matches = t.matches_to_update.to_a
  end

  def statistics
    @user = params[:user_id].blank? ? current_user : User.find(params[:user_id])
    @predicted_teams = @user.predicted_teams_by_match_id
  end

  def correct_predictors
    @current_tournament = Tournament.find(params[:tournament_id])
    @match = Match.find(params[:match_id])
  end

end
