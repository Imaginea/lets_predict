set :output, "log/schedular.log"

every '00 14,18 * * *' do
  runner "User.send_prediction_reminder"
end