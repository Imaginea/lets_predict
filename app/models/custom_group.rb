class CustomGroup < ActiveRecord::Base
  attr_accessible :group_name, :user_id, :total_members
  
  belongs_to :user
  has_many :group_connections, :dependent => :destroy
  #has_many :members, :through => :group_connections, :source => :user

  validates :group_name, :presence => true, 
  :uniqueness => { :case_sensitive => false }, :length => { :in => 3..25 }
  validates :user_id, :uniqueness => { :message => 'owns a group already' }

  ALLOWED_MEMBERS_COUNT = 10

  scope :to_join, lambda { |uid|
    where("custom_groups.id NOT IN (#{GroupConnection.group_ids_for(uid).to_sql})")
  }

  def connected_members_ids
  	@conn_member_ids ||= self.group_connections.active.pluck(:user_id)
  end

  def invited_members_ids
    @invited_member_ids ||= self.invited_members.pluck(:user_id)
  end

  def members_ids
    @member_ids ||= self.group_connections.pluck(:user_id)
  end

  # returns scoped group connections to chain and fetch the members
  # better than a has_many :through, as in most cases we want to chain on this.
  def members
   self.group_connections.includes(:user)
  end

  def waiting_members
    self.group_connections.waiting
  end

  def invited_members
    self.group_connections.invited
  end

  def waiting_members_count
    @waiting_members_cnt ||= self.waiting_members.count
  end

  def requested_members_count
  	@req_members_cnt ||= self.group_connections.requested.count
  end

  def can_join?
    self.requested_members_count < ALLOWED_MEMBERS_COUNT - 1 # owner is also a member
  end

  def join!(usr_id, status = nil)
    opts = { :user_id => usr_id }
    opts.update(:status => status) if status

    joined = self.group_connections.build(opts).save
    joined && send_join_notification!(usr_id, status)
  end

  def invite!(usr)
    return false if usr.reached_group_limit?
    join!(usr.id, 'invited')
  end

  def cancel_invite!(usr_id)
    gc = self.invited_members.where(:user_id => usr_id).first
    gc.try(:reject!)
  end

  private
  
  def send_join_notification!(usr_id, status = nil)
    if status
      UserMailer.delay.new_group_invite(self.user_id, usr_id)
    else
      UserMailer.delay.new_group_request(self.user_id)
    end
    true
  end
end
