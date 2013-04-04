class UsersController < ApplicationController
  before_filter :restrict_to_my_account, :only => [:show]
  before_filter :restrict_to_open_tournaments, :only => [:leaderboard]

  def show
    @new_tournament = Tournament.current_tournaments
  end
  
  def leaderboard   
  end

  def location_change
    @locations = User.where('location NOT IN (?)', ['default', "Begumpet"])
  end 

  def update
    respond_to do |format|
      if current_user.update_attributes(:location => params[:location])
        format.html { redirect_to home_path, notice: 'Location updated.' }
      end
    end
  end

  private

  def restrict_to_my_account
    access_denied if params[:id]
  end
end
