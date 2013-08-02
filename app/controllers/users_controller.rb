class UsersController < ApplicationController
  before_filter :restrict_params, :only => [:show]
  before_filter :restrict_to_my_account, :only => [:update]
  before_filter :restrict_to_open_tournaments, :only => [:leaderboard]
  def show
    @new_tournaments = Tournament.current_tournaments.to_a
    @past_tournaments = Tournament.past_tournaments
    @user_ids = CustomGroup.all.map{|a| a.user_id }
    #@group_exist = @user_ids.include?(current_user.id) ? true : false
    unless current_user.custom_group.nil?
      @new_invitations = GroupConnection.where('custom_group_id =? AND status =?', current_user.custom_group.id, "pending")
      @count = @new_invitations.count
      unless @new_invitations.empty?
        if @count == 1
          flash.now[:notice] = %Q[ <FONT COLOR="#0088CC"> #{@new_invitations.first.user.fullname} </FONT> wants to join your group <a href="/invitations">#{current_user.custom_group.group_name}.</a>].html_safe
        elsif @count == 2
          flash.now[:notice] = %Q[ <FONT COLOR="#0088CC"> #{@new_invitations.first.user.fullname}, #{@new_invitations.last.user.fullname} </FONT> wants to join your group <a href="/invitations">#{current_user.custom_group.group_name}.</a>].html_safe
        elsif @count > 2
          flash.now[:notice] = %Q[ <FONT COLOR="#0088CC"> #{@new_invitations.last.user.fullname} </FONT> and <FONT COLOR="#8B0000"> #{@count-1} others </FONT> wants to join your group <a href="/invitations">#{current_user.custom_group.group_name}.</a>].html_safe
        end
      end
    end
  end

  def leaderboard
  end

  def location_change
    @locations = User::VALID_LOCATIONS
  end

  def update
    current_user.update_attribute(:location, params[:location])
    redirect_to home_path, :notice => 'Location updated.' # assume success always
  end

  def invitations
    @user = current_user
    @invitations = GroupConnection.where('custom_group_id =? AND status =?', @user.custom_group.id, "pending")
  end

  private

  def restrict_params
    access_denied if params[:id]
  end

  def restrict_to_my_account
    access_denied unless params[:id].to_i == current_user.id
  end

end
