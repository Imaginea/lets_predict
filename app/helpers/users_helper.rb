module UsersHelper

  def get_btn_class(predicted_teams, match, team_name)
    return 'cant-predict' unless match.can_predict?
    match_id = match.id
    return "btn btn-primary btn-block" if predicted_teams[match_id].blank?
    return "btn btn-success btn-block disabled" if predicted_teams[match_id].second == team_name
    "btn btn-block"
  end

  def get_icon_class(predicted_teams, match_id, team_name)
    return "icon-ok pull-right hide" if predicted_teams[match_id].blank?
    return "icon-ok pull-right" if predicted_teams[match_id].second == team_name
    "icon-ok pull-right hide"
  end

  def get_accordion_class(show = true)
    "accordion-body collapse #{show ? 'in' : ''}"
  end

end
