class GroupConnection < ActiveRecord::Base

  attr_accessible :custom_group_id, :status, :user_id

  belongs_to :user
  belongs_to :custom_group

  STATUS = %w(pending connected)
         
  scope :requested_groups, where(:status => STATUS)
  scope :own_group, lambda { where('status =?', "own") }
  scope :connected_members, where('status =?', "connected")

  def connected_groups(usr_id)
    @connected_groups = self.custom_group.includes(:custom_group_id, :status).where('user_id =?', usr_id)
  end

  def specific_group_connected_users_arr
    self.custom_group.total_connected_members_arr
  end

end
