set :output, "log/schedular.log"

every '00 15 * * *' do
  runner "User.send_prediction_reminder"
end 

every '00 19 * * *' do
  runner "User.send_prediction_reminder"
end