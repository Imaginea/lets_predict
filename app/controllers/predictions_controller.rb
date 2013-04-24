class PredictionsController < ApplicationController
  before_filter :restrict_to_closed_tournaments, :only => [:predict]

  def create
    predictions = params[:predictions].values + params[:non_league_predictions].values
    t_id = predictions.first[:tournament_id].to_i
    matches = Match.where(:tournament_id => t_id).to_a.group_by(&:id)
    user_predictions = current_user.predictions.where(:tournament_id => t_id).group_by(&:match_id)
      predictions.each do |prediction|
        m_id = prediction[:match_id].to_i
        next unless matches[m_id].try(:first).try(:can_predict?)
        
        pred = user_predictions[m_id] || [current_user.predictions.build(
          :match_id => m_id, :tournament_id => t_id )]
        pred = pred.first
        pred.predicted_team_id = prediction[:predicted_team_id]
        pred.save!
      end
    redirect_to home_url, :notice => 'Predictions updated successfully.'
  end

  def predict
    @predicted_teams = current_user.predicted_teams_by_match_id
    @teams = Team.all
  end

  def users_playing
    @current_tournament =  Tournament.find(params[:tournament_id])
  end 

end
