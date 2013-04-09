class UserMailer < ActionMailer::Base
  default from: "lets-predict-noreply@imaginea.com"
  USER_GROUP = "all@pramati.com"
  def new_tournament_email(tournaments)
    @tournaments = tournaments
    @url  = "http://predict.imaginea.com"
    #mail(:to => USER_GROUP, :subject => "New Tournament available for prediction")
    mail(:to => "supraja.s@imaginea.com", :subject => "New Tournament available for prediction")
  end
end


  