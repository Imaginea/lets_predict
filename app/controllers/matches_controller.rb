class MatchesController < ApplicationController
  before_filter :restrict_to_open_tournaments, :only => [:statistics]
  before_filter :restrict_to_admins, :only => [:update, :update_results]

  def update
    match = Match.find(params[:id])
    match.update_attribute(:winner_id, params[:winner_id])

    pred_scope = Prediction.where(:match_id  => match.id, :predicted_team_id => match.winner_id)
    res = pred_scope.update_all(:points => match.success_points)
    redirect_to :back, :notice => "Updated #{res} correct predictions with #{match.success_points} points"
  end

  def update_results
    t = Tournament.find(params[:tournament_id])
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
