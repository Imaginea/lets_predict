module ApplicationHelper

  def prediction_status_color(predicted_team_id, team, winner_id)
    return '#333333' if team.blank? || predicted_team_id != team.id
    return 'blue' if predicted_team_id && winner_id.nil?
    predicted_team_id == winner_id ? 'green' : 'red'
  end

  def prediction_accuracy_color(accuracy_percent)
    return 'red' if (accuracy_percent*100) < 50
  end

  def countdown_time_json(date_time)
    t = date_time.strftime('%Y-%m-%d-%H-%M-%S').split('-')
    {:year => t[0], :month => t[1].to_i-1, :day => t[2],
     :hours => t[3], :minutes => t[4], :seconds => t[5]
    }.to_json
  end

  def render_group_members(group, hide_link = false)
    cnt = content_tag(:span, "(#{group.total_members} active) ", :class => 'strong')
    return cnt if @tournament_running

    waiting_cnt = group.waiting_members_count
    waiting_txt = "#{waiting_cnt} pending"
    waiting_lnk = link_to waiting_txt, waiting_list_custom_group_path(group), :remote => true
    hide_link ||= waiting_cnt.zero?

    cnt << content_tag(:span) do
      '['.html_safe << (hide_link ? waiting_txt : waiting_lnk) << ']'
    end
    cnt.html_safe
  end
end
