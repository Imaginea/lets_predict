class CustomGroupsController < ApplicationController
  before_filter :restrict_to_running_tournaments, :except => :index
  include CustomGroupsHelper

  def index
    @current_tournament =  Tournament.find(params[:tournament_id])
    @tournament_running = Tournament.any_running?
    @own_group = current_user.custom_group
    scope = @tournament_running ? :connected : :requested
    @connections = current_user.group_connections.send(scope).includes(:custom_group).to_a
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

  def new_invite
    exclude_ids = current_user.custom_group.try(:members_ids) || []
    @invitees = User.where('id NOT IN (?)', exclude_ids).select([:id, :fullname]).to_a
  end

  def create_invite
    @user = User.where(:fullname => params[:name]).first
    if @user && current_user.custom_group.try(:invite!, @user)
      flash[:notice] = "Successfully invited #{@user.fullname}"
    else
      flash[:error] = "Failed. User not found or user reached limit!"
    end
    redirect_to custom_groups_url
  end

  def cancel_invite
    if current_user.custom_group.try(:cancel_invite!, params[:user_id].to_i)
      flash[:notice] = 'Cancelled successfully'
    else
      flash[:error] = 'Failed. User not in group or already approved!'
    end
    redirect_to custom_groups_url
  end

  def accept_invite
  end

  def ignore_invite
  end

  def waiting_list
    group = CustomGroup.find(params[:id])
    @users = group.waiting_members.includes(:user).collect(&:user)
    @invited_user_ids = group.invited_members_ids
    @show_actions = group.user_id == current_user.id
  end
end
