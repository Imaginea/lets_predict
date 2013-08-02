class UserMailer < ActionMailer::Base
  default :from => "lets-predict-noreply@imaginea.com" 
  USER_GROUP = "all@pramati.com"
  def new_tournament_email(newtournaments)
    @tournaments = newtournaments
    @url= "http://predict.imaginea.com"
    #mail(:to => USER_GROUP, :subject => "New Tournament available for prediction")
    mail(:to => "supraja.s@imaginea.com", :subject => "Lets-Predict - New Tournament available for prediction")
  end

  def tournament_update_email(currenttournaments)
    @tournaments = currenttournaments
    @url= "http://predict.imaginea.com"
    #mail(:to => USER_GROUP, :subject => "New Tournament available for prediction")
    mail(:to => "supraja.s@imaginea.com", :subject => "Lets-Predict - Tournament Update")
  end

  def owner_reminder(requesteduser)
    @user = requesteduser
    @owner_email = requesteduser.email
    mail(:to => @owner_email, :subject => "Lets-Predict - Request Accept Reminder")
  end

  def group_deletion_alert

  end

  def new_request_notification(grpowner)
    @user = grpowner 
    @email = @user.email
    mail(:to => @email, :subject => "Lets-Predict - New Request Notification")
  end

  def request_acceptance_notification

  end

end