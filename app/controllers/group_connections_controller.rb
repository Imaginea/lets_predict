# A non-resourceful controller claiming to be so.
class GroupConnectionsController < ApplicationController
  before_filter :load_group_connection, :except => [:join_req]

  def join_req
  	group_id = params[:group_id].to_i
    group = CustomGroup.find_by_id(group_id)

    if current_user.reached_group_limit?
      flash[:alert] = "Sorry, You can only be part of 3 groups, max. To join more, disconnect/revoke from any of the current groups."
    elsif group.try(:join!, current_user.id)
      flash[:notice] = "Your request to join #{group.group_name} has to be approved by #{group.user.fullname}"
    end
    redirect_to :back
  end

  def user_disconnect
    flash[:notice] = "Disconnected from the group - #{@gc.custom_group.group_name}." if @gc.try(:disconnect!)
    redirect_to :back
  end

  def accept_invitation
    flash[:notice] = "Successfully added #{@gc.user.fullname} to your group." if @gc.try(:approve!)
    redirect_to :back
  end

  def ignore_invitation
    flash[:notice] = "Ignored request from #{@gc.user.fullname}." if @gc.try(:reject!)
    redirect_to :back
  end

  def owner_reminder
    owner = User.find_by_id(params[:owner_id].to_i)
    flash[:notice] = "Remained #{owner.fullname} about your join request." if @gc.try(:remaind_owner!, owner)
    redirect_to :back
  end

  private

  def load_group_connection
    @gc = GroupConnection.find_by_id(params[:id].to_i)
  end
end
