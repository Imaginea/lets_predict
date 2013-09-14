class UserMailer < ActionMailer::Base
  default :from => "lets-predict-noreply@imaginea.com" 
  USER_GROUP = "chennai@imaginea.com"

  def new_tournament_email(newtournaments)
    @tournaments = newtournaments
    @url = "http://predict.imaginea.com"
    mail(:to => USER_GROUP, :subject => "#{subj_prefix}New Tournament available for prediction")
  end

  def tournament_update_email(currenttournaments)
    @tournaments = currenttournaments
    @url = "http://predict.imaginea.com"
    mail(:to => USER_GROUP, :subject => "#{subj_prefix}Tournament Update")
  end

  def group_owner_reminder(owner_id)
    @owner = User.find(owner_id)
    @pending_users = owner.custom_group.members.pending.collect { |gc| gc.user.fullname }
    mail(:to => @owner.email, :subject => "#{subj_prefix}Reminder on pending group requests")
  end

  def group_deletion(grp_name, to_emails)
    generic_mail(to_emails, 'Deleted group {group}', :group => grp_name)
  end

  def new_group_request(owner_id)
    owner = User.find(owner_id)
    user = owner.custom_group.members.pending.recent.first.user
    generic_mail(owner.email, '{user} wants to join your group', :user => user.fullname)
  end

  def new_group_invite(owner_id, invitee_id)
    owner, invitee = User.find(owner_id), User.find(invitee_id)
    grp_name = owner.custom_group.group_name
    subj = '{user} has invited you to join group #{group}'
    generic_mail(invitee.email, subj, :user => owner.fullname, :group => grp_name)
  end

  def group_request_acceptance(gc_id)
    gc = GroupConnection.find(gc_id)
    grp_name = gc.custom_group.group_name
    generic_mail(gc.user.email, 'Approved for group {group}', :group => grp_name)
  end

  def group_invite_acceptance(gc_id)
    gc = GroupConnection.find(gc_id)
    owner, user = gc.custom_group.user, gc.user
    generic_mail(owner.email, '{user} has joined your group', :user => user.fullname)
  end

  def group_request_rejection(to_email, grp_name)
    generic_mail(to_email, 'Rejected for group {group}', :group => grp_name)
  end

  def disconnected_from_group(user_id, group_id, pending)
    user, group = User.find(user_id), CustomGroup.find(group_id)
    to_emails = [group.user.email]
    tokens = { :user => user.fullname }

    subj = if pending
      '{user} disconnected from your group'
    else
      to_emails = group.members.collect { |gc| gc.user.email }
      tokens[:group] = group.group_name
      '{user} disconnected from group {group}'
    end
    generic_mail(to_emails, subj, tokens)
  end

  protected

  # Common bodyless mails that varies only in :to and :subject
  # :subject can optionally be tokenized like I18n.t method
  def generic_mail(to_emails, subject, tokens = {})
    subject = subj_prefix << subject
    tokens.each { |token, val| subject.gsub!(/{#{token.to_s}}/, val) }
    subject << ' <EOM>'

    mail(:to => to_emails, :subject => subject, :body => '')
  end

  def subj_prefix
    'Lets-Predict: '
  end
end
