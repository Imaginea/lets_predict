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

  def group_owner_reminder(owner)
    @owner = owner
    @pending_users = owner.custom_group.members.pending.collect { |gc| gc.user.fullname }
    mail(:to => @owner.email, :subject => "#{subj_prefix}Reminder on pending group requests")
  end

  def group_deletion(grp)
    owner_name = grp.user.fullname
    to_emails = grp.members.requested.collect { |gc| gc.user.email }
    generic_mail(to_emails, 'Deleted group {group}', :group => grp.group_name)
  end

  def new_group_request(owner)
    owner = owner
    user = owner.custom_group.members.pending.recent.first.user
    generic_mail(owner.email, '{user} wants to join your group', :user => user.fullname)
  end

  def group_request_acceptance(gc)
    group_connection_mail(gc, 'Approved for group {group}')
  end

  def group_request_rejection(gc)
    group_connection_mail(gc, 'Rejected for group {group}')
  end

  def disconnected_from_group(gc)
    user, group = gc.user, gc.custom_group
    to_emails = [group.user.email]
    tokens = { :user => user.fullname }

    subj = if gc.pending?
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

  # GroupConnection bodyless mails dont change only in subject
  def group_connection_mail(gc, subject)
    grp_name = gc.custom_group.group_name
    subject = subj_prefix << subject.gsub(/{group}/, grp_name) << ' <EOM>'

    mail(:to => gc.user.email, :subject => subject, :body => '')
  end

  def subj_prefix
    'Lets-Predict: '
  end
end
