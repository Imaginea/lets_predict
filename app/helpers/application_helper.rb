module ApplicationHelper

  def prediction_status_color(predicted_team_id, team, winner_id)
    return '#333333' if team.blank? || predicted_team_id != team.id
    return 'blue' if predicted_team_id && winner_id.nil?
    predicted_team_id == winner_id ? 'green' : 'red'
  end

  def prediction_accuracy_color(accuracy_percent)
    return 'red' if (accuracy_percent*100) < 50
  end 
  
end
