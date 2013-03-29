class PredictionsController < ApplicationController
  before_filter :restrict_to_closed_tournaments, :only => [:predict]

  def create
    predictions = params[:predictions].values + params[:non_league_predictions].values
    t_id = predictions.first[:tournament_id].to_i
    user_predictions = current_user.predictions.where(:tournament_id => t_id).group_by(&:match_id)
    #begin
      predictions.each do |prediction|
        m_id = prediction[:match_id].to_i
        pred = user_predictions[m_id] || [current_user.predictions.build(
          :match_id => m_id, :tournament_id => t_id )]
        pred = pred.first
        pred.predicted_team_id = prediction[:predicted_team_id]
        pred.save!
      end
    #rescue
       #current_user.predictions.delete_all
      # flash[:error] = "Error while updating few records."
    #end
    redirect_to home_url, :notice => 'Predictions updated successfully.'
  end

  def predict
    #@user = current_user
    @prediction = Prediction.new
    @predicted_teams = current_user.predicted_teams_by_match_id
    @teams = Team.all
  end
end
