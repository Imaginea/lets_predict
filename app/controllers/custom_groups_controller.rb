class CustomGroupsController < ApplicationController

  def new
    @grp = CustomGroup.new
    @id = current_user.id
  end

  def create
    @id = current_user.id
    @name = params[:custom_group][:group_name]
    @cg = CustomGroup.new(:group_name => @name, :user_id => @id, :total_members => 1)
    if @cg.save
      GroupConnection.create!(:custom_group_id => @cg.id, :user_id => current_user.id, :status => "own")
      flash[:notice] = "Group Created Successfully."
    else
      flash[:alert] = "Unable to create the Group or Group Name has already been taken."
    end
    redirect_to :back
  end

  def edit

  end

  def delete_group
    @id = current_user.id
    @group = CustomGroup.find_by_user_id(@id)
    @group.destroy
    redirect_to :back
  end

  def groups_list
    @id = current_user.id
    @current_tournament = Tournament.find params[:tournament_id]
    @all_tournaments = Tournament.all
    @all_tournaments.each do |t|
      unless t.finished?
        @tournament_running = true
      end
    end
    @groups = CustomGroup.all
    #For checking current user group
    @user_ids = CustomGroup.all.map{|c| c.user_id}
    if @user_ids.include?(current_user.id)
      @own_group = CustomGroup.find_by_user_id(current_user.id)
      @members_connected = current_user.members_connected
      @group_exist = true
    else
      @group_exist = false
    end
    #New queries for connected and pending requests
    @connected_groups = current_user.connected_groups
    @req_pending_groups = current_user.pending_group_connections
    new_groups
  end


  #For Joining to New Groups
  def new_groups  
    @current_tournament = Tournament.find params[:tournament_id].to_i
    @id = current_user.id
    @groups = CustomGroup.all
    @old_connections = GroupConnection.where('user_id =? AND status is NOT NULL', @id)
    @all_groups = @groups.map{|i| i.id }
    @connections_ids = @old_connections.map{|i| i.custom_group_id}
    @new_ids = @all_groups - @connections_ids
    @arr_ng = []
    @new_ids.each do |i|
      @arr_ng << CustomGroup.find_by_id(i)
    end
  end

end