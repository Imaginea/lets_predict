class CustomGroup < ActiveRecord::Base
  attr_accessible :group_name, :user_id, :total_members
  
  belongs_to :user
  
  has_many :group_connections, :dependent => :destroy

  validates :group_name, :presence => {:message => "Can't Be Blank"}, 
  :uniqueness => { :case_sensitive => false }, :length => { :in => 3..25 }

  def total_connected_members_arr
  	self.group_connections.where(:status => ["connected", "own"]).map{|i| i.user_id }	
  end

  def members_count
  	self.group_connections.where(:status => ["connected", "pending"]).count
  end

  def own_grp_connection_record
    self.group_connections.find_by_status("own")
  end

end
