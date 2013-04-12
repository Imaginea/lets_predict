namespace :tournament do

  desc "Send New Tournament Notification Email"
  task :send_notification => :environment do
    tournaments = Tournament.current_tournaments.where(:notified => false).to_a
    if tournaments.any?
      UserMailer.new_tournament_email(tournaments).deliver
      t_ids = tournaments.collect{|x| x.id}    
      Tournament.where(:id => t_ids).update_all(:notified => true)
    end
  end
end 