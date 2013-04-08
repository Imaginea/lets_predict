require 'rake'
class MatchesController < ApplicationController
  before_filter :restrict_to_open_tournaments, :only => [:statistics]

  def update
    match = Match.find(params[:id])
    match.update_attribute(:winner_id, params[:winner_id])

    pts = match.success_points
    preds = Prediction.where(:match_id => match.id, :predicted_team_id => match.winner_id).to_a
    preds.each do |p|
      p.update_attribute(:points, pts)
    end
    redirect_to :back  
  end

  def update_results
    @tournament = Tournament.find(params[:tournament_id])
  end

  def statistics
    @user = params[:user_id].blank? ? current_user : User.find(params[:user_id])
    @predicted_teams = @user.predicted_teams_by_match_id
  end

end
