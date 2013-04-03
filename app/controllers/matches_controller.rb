class MatchesController < ApplicationController
  before_filter :restrict_to_open_tournaments, :only => [:statistics]

  def statistics
    @user = params[:user_id].blank? ? current_user : User.find(params[:user_id])
    @predicted_teams = @user.predicted_teams_by_match_id
  end
end
