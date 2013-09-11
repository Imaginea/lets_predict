class CustomGroup < ActiveRecord::Base
  attr_accessible :group_name, :user_id, :total_members
  
  belongs_to :user
  has_many :group_connections, :dependent => :destroy
  #has_many :members, :through => :group_connections, :source => :user

  validates :group_name, :presence => true, 
  :uniqueness => { :case_sensitive => false }, :length => { :in => 3..25 }
  validates :user_id, :uniqueness => { :message => 'owns a group already' }

  scope :to_join, lambda { |uid|
    where("custom_groups.id NOT IN (#{GroupConnection.group_ids_for(uid).to_sql})")
  }

  ALLOWED_MEMBERS_COUNT = 10

  def connected_members_ids
  	@member_ids ||= self.group_connections.active.pluck(:user_id)
  end

  # returns scoped group connections to chain and fetch the members
  # better than a has_many :through, as in most cases we want to chain on this.
  def members
   self.group_connections.includes(:user)
  end

  def requested_members_count
  	@req_members_cnt ||= self.group_connections.requested.count
  end

  def can_join?
    self.requested_members_count < ALLOWED_MEMBERS_COUNT - 1 # owner is also a member
  end

  def join!(usr_id)
    joined = self.group_connections.build(:user_id => usr_id).save
    UserMailer.new_group_request(self.user).deliver if joined
    joined
  end
end
