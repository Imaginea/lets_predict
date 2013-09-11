class GroupConnection < ActiveRecord::Base

  attr_accessible :custom_group_id, :status, :user_id

  belongs_to :user
  belongs_to :custom_group

  validates :user_id, :status, :presence => true

  STATUS = %w(pending connected own)
         
  scope :requested, where(:status => ['pending', 'connected'])
  scope :pending, where(:status => 'pending')
  scope :own, where(:status => 'own')
  scope :connected, where(:status => 'connected')
  scope :active, where(:status => ['connected', 'own'])
  
  scope :recent, order('created_at DESC')
  scope :group_ids_for, lambda { |usr_id| where(:user_id => usr_id).select(:custom_group_id) }

  # define pending?, connected? and own? methods
  STATUS.each do |state|
    define_method "#{state}?" do
      self.status == state
    end
  end

  def approve!
    return true if self.connected?

    status = self.update_attribute(:status, 'connected')
    UserMailer.group_request_acceptance(self).deliver if status
    status && self.custom_group.increment!(:total_members)
  end

  def reject!
    return false if self.connected?

    status = self.destroy
    UserMailer.group_request_rejection(self).deliver if status
    status
  end

  def disconnect!
    status = self.destroy
    UserMailer.disconnected_from_group(self).deliver if status
    return status if self.pending?
    status && self.custom_group.decrement!(:total_members)
  end

  def remaind_owner!(owner = nil)
    return true if self.owner_remind?
    return false unless self.pending?

    owner ||= self.custom_group.user
    UserMailer.group_owner_reminder(owner).deliver
    self.update_attribute(:owner_remind, true)
  end
end
