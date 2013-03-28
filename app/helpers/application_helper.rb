module ApplicationHelper

  def get_prediction_percentage(predicted_teams,tournament)
    percentage = ((predicted_teams.count.to_f/tournament.matches.count)*100).round()
    return "#{percentage}%"
  end

end
