class UserMailer < ActionMailer::Base
  default from: "lets-predict-noreply@imaginea.com"
  USER_GROUP = "all@pramati.com"
  URL = "http://predict.imaginea.com"
  def new_tournament_email(newtournaments)
    @tournaments = newtournaments
    #mail(:to => USER_GROUP, :subject => "New Tournament available for prediction")
    mail(:to => "supraja.s@imaginea.com", :subject => "Lets-Predict - New Tournament available for prediction")
  end

  def tournament_update_email(currenttournaments)
    @tournaments = currenttournaments
    #mail(:to => USER_GROUP, :subject => "New Tournament available for prediction")
    mail(:to => "supraja.s@imaginea.com", :subject => "Lets-Predict - Tournament Update")
  end
end