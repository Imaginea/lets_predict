namespace :tournament do

  desc "Send New Tournament Notification Email"
  task :send_notification => :environment do
    tournaments = Tournament.upcoming_tournaments
    UserMailer.new_tournament_email(tournaments).deliver
  end
end 