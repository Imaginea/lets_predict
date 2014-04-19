class UsersController < ApplicationController
  before_filter :restrict_params, :only => [:show]
  before_filter :restrict_to_my_account, :only => [:update]
  before_filter :restrict_to_open_tournaments, :only => [:leaderboard]

  def show
    @new_tournaments = Tournament.current_tournaments.to_a
    @past_tournaments = Tournament.past_tournaments
    @invitations_cnt = Tournament.any_running? ? 0 : current_user.invitations.count
  end

  def leaderboard
    loc = params[:loc]
    @users = @current_tournament.leaderboard_users(loc).all
  end

  def location_change
    @locations = User::VALID_LOCATIONS
  end

  def update
    current_user.update_attribute(:location, params[:location])
    redirect_to home_path, :notice => 'Location updated.' # assume success always
  end

  # invitations are turned off as soon as the tournament starts
  def invitations
    @invitations = Tournament.any_running? ? [] : current_user.invitations.to_a
  end

  private

  def restrict_params
    access_denied if params[:id]
  end

  def restrict_to_my_account
    access_denied unless params[:id].to_i == current_user.id
  end
end
