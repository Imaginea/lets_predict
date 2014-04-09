set :output, "log/schedular.log"

every '00 14 * * *' do
  runner "User.send_prediction_reminder"
end 

every '00 18 * * *' do
  runner "User.send_prediction_reminder"
end