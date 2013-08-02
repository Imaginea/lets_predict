class GroupConnectionsController < ApplicationController

  def join_req
  	@group_id = params[:group_id].to_i
    @custom_group = CustomGroup.find(@group_id) 
    if current_user.group_connections.requested_groups.count == 3
      flash[:alert] = "Oops! You can send max upto three requests. To send more, disconnect or revoke from the existing ones."
    else
      @new_gc = GroupConnection.create!(:custom_group_id => params[:group_id].to_i, 
       :user_id => current_user.id, :status => "pending")
      @owner = User.find_by_id(@new_gc.custom_group.user_id)
      UserMailer.new_request_notification(@owner).deliver
      flash[:notice] = "Your request to join the group #{@custom_group.group_name} is sent successfully."
    end
    redirect_to :back
  end

  def user_disconnect
    @connection = GroupConnection.find_by_id(params[:group_connection_id].to_i)
    @custom_group = CustomGroup.find_by_id(@connection.custom_group_id)
    if params[:reqstatus] == "connected"
      @connection.custom_group.update_attribute('total_members', @connection.custom_group.total_members - 1)
    end
    @connection.destroy
    redirect_to :back
    flash[:notice] = "Successfully disconnected from the group #{@custom_group.group_name}."
  end

  def accept_invitation
     @gc = GroupConnection.find_by_id(params[:group_connection_id].to_i)
     @gc.update_attribute("status", "connected")
     @gc.custom_group.update_attribute('total_members', @gc.custom_group.total_members + 1)
     redirect_to :back
     flash[:notice] = "#{@gc.user.fullname} was successfully added to your group #{@gc.custom_group.group_name}."
  end

  def ignore_invitation
    @connection = GroupConnection.find_by_id(params[:group_connection_id].to_i)
    @connection.delete
    redirect_to :back
  end

  def owner_reminder
    @owner = User.find_by_id(params[:owner_id].to_i)
    @gc = GroupConnection.find_by_id(params[:id].to_i)
    UserMailer.owner_reminder(@owner).deliver
    @gc.update_attribute('owner_remind','true')
    flash[:notice] = "Reminder mail to the owner #{@owner.fullname} sent successfully."
    redirect_to :back
  end

end