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
end