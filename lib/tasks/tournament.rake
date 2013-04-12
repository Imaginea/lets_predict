namespace :tournament do

  desc "Send New Tournament Notification Email"
  task :notify_new => :environment do
    tournaments = Tournament.current_tournaments.where(:notified => false).to_a
    if tournaments.any?
      UserMailer.new_tournament_email(tournaments).deliver
      t_ids = tournaments.collect{|x| x.id}    
      Tournament.where(:id => t_ids).update_all(:notified => true)
    end
  end
  desc "Send Weekly Updates via Email"
  task :send_update => :environment do
    tournaments = Tournament.active_tournaments.to_a
    if tournaments.any?
        UserMailer.tournament_update_email(tournaments).deliver
    end
  end
end