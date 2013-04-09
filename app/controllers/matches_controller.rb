class MatchesController < ApplicationController
  before_filter :restrict_to_open_tournaments, :only => [:statistics]
  before_filter :restrict_to_admins, :only => [:update, :update_results]

  def update
    match = Match.find(params[:id])
    match.update_attribute(:winner_id, params[:winner_id])

    pts, success = match.success_points, 0
    preds = Prediction.where(:match_id => match.id, :predicted_team_id => match.winner_id).to_a
    preds.each_with_index do |p, i|
      p.update_attribute(:points, pts)
      success += 1
    end
    redirect_to :back, :notice => "Updated #{success} correct predictions with #{pts} points"
  end

  def update_results
    t = Tournament.find(params[:tournament_id])
    @matches = t.matches_to_update.to_a
  end

  def statistics
    @user = params[:user_id].blank? ? current_user : User.find(params[:user_id])
    @predicted_teams = @user.predicted_teams_by_match_id
  end

end
