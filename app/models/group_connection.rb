class GroupConnection < ActiveRecord::Base

  attr_accessible :custom_group_id, :status, :user_id

  belongs_to :user
  belongs_to :custom_group

  validates :user_id, :status, :presence => true

  STATUS = %w(pending invited connected own)

  STATUS.each do |state|
    scope state.to_sym, where(:status => state)
  end
  scope :requested, where(:status => ['invited', 'pending', 'connected'])
  scope :waiting, where(:status => ['invited', 'pending'])
  scope :active, where(:status => ['connected', 'own'])
  
  scope :recent, order('created_at DESC')
  scope :group_ids_for, lambda { |usr_id| where(:user_id => usr_id).select(:custom_group_id) }

  # scope of invited connections or pending connections for a user
  def self.pending_connections(usr)
    conds = ["(user_id = #{usr.id} AND status = 'invited')"]
    usr_group = usr.custom_group
    conds << "(custom_group_id = #{usr_group.id} AND status = 'pending')" if usr_group

    self.where(conds.join(' OR '))
  end

  # define pending?, invited?, connected? and own? methods
  STATUS.each do |state|
    define_method "#{state}?" do
      self.status == state
    end
  end

  def waiting?
    self.pending? || self.invited?
  end

  def approve!
    return true if self.connected?

    was_invited = self.invited?
    status = self.update_attribute(:status, 'connected')
    send_acceptance_mail!(was_invited) if status
    status && self.custom_group.increment!(:total_members)
  end

  def reject!
    return false if self.connected?

    status = self.destroy
    status && send_rejection_mail!
  end

  def disconnect!
    status = self.destroy
    args = [self.user_id, self.custom_group_id, self.pending?]
    UserMailer.delay.disconnected_from_group(*args) if status
    return status if self.waiting?
    status && self.custom_group.decrement!(:total_members)
  end

  def remaind_owner!(owner_id = nil)
    return true if self.owner_remind?
    return false unless self.pending?

    owner_id ||= self.custom_group.user_id
    UserMailer.delay.group_owner_reminder(owner_id)
    self.update_attribute(:owner_remind, true)
  end

  private

  def send_acceptance_mail!(was_invited)
    if was_invited
      UserMailer.delay.group_invite_acceptance(self.id)
    else
      UserMailer.delay.group_request_acceptance(self.id)
    end
    true
  end

  # don't send mail when group owner cancels an invite
  # or when the invitee ignores the invitation
  def send_rejection_mail!
    return true if self.invited?
    args = [self.user.email, self.custom_group.group_name]
    UserMailer.delay.group_request_rejection(*args)
    true
  end
end
