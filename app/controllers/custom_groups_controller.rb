class CustomGroupsController < ApplicationController
  before_filter :restrict_to_closed_tournaments
  include CustomGroupsHelper

  def index
    @tournament_running = Tournament.any_running?
    @own_group = current_user.custom_group
    @connections = current_user.group_connections.includes(:custom_group).to_a
    @groups_to_join = CustomGroup.to_join(current_user.id).count
  end

  def new
    @grp = CustomGroup.new
  end

  def create
    name = params[:custom_group][:group_name]
    if current_user.create_my_group(name)
      flash[:notice] = "Group created successfully."
    else
      flash[:alert] = "Failed: Group name has already been taken or its too short. Please try again!"
    end
    redirect_to custom_groups_url
  end

  def edit
  end

  def delete_group
    status = current_user.delete_my_group
    flash[:notice] = 'Your group has been deleted completely' if status
    redirect_to custom_groups_url
  end

  #For Joining to New Groups
  def new_groups
    @groups = CustomGroup.to_join(current_user.id).includes(:user).all
  end
end
