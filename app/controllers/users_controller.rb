class UsersController < ApplicationController
  before_filter :restrict_params, :only => [:show]
  before_filter :restrict_to_my_account, :only => [:update]
  before_filter :restrict_to_open_tournaments, :only => [:leaderboard]

  def show
    @new_tournament = Tournament.current_tournaments
  end
  
  def leaderboard   
  end

  def location_change
    @locations = User.valid_locations
  end 

  def update
    current_user.update_attribute(:location, params[:location])
    redirect_to home_path, :notice => 'Location updated.' # assume success always
  end

  private

  def restrict_params
    access_denied if params[:id]
  end

  def restrict_to_my_account
    access_denied unless params[:id].to_i == current_user.id
  end
end
