module ApplicationHelper

  def get_prediction_percentage(predicted_teams,tournament)
    percentage = ((predicted_teams.count.to_f/tournament.matches.count)*100).round()
    return "#{percentage}%"
  end

  def prediction_status_color(predicted_team_id, team, winner_id)
    return '#333333' if team.blank? || predicted_team_id != team.id
    return 'blue' if predicted_team_id && winner_id.nil?
    predicted_team_id == winner_id ? 'green' : 'red'
  end
end
