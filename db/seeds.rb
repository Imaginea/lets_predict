# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
#Creating Tournaments
# puts "Creating Tournaments...."
# Tournament.create!(:name => 'West Indies Tri-Series', :start_date => Date.today + 1, :end_date => Date.today + 4, :sport => 'Cricket')
# puts "Created Tournaments."


#Creating Teams
# puts "Creating Teams...."
# ['India', 'Srilanka', 'Australia', 'West Indies', 'England', 'Newzealand', 'South Africa'].each do |team_name|
  # Team.create!(:name => team_name)
# end
# puts "Created Teams."


puts "Creating matches....."
# Match.create!(:tournament_id => 2, :team_id => 9, :date => "2013-06-27 19:00:00", :venue => "Kingston", :match_type => "league", :opponent_id => 6)
# Match.create!(:tournament_id => 2, :team_id => 9, :date => "2013-06-28 19:00:00", :venue => "Kingston", :match_type => "league", :opponent_id => 7)
# Match.create!(:tournament_id => 2, :team_id => 6, :date => "2013-06-29 19:00:00", :venue => "Kingston", :match_type => "semifinal", :opponent_id => 7)
# Match.create!(:tournament_id => 2, :team_id => 6, :date => "2013-06-30 19:00:00", :venue => "Kingston", :match_type => "final", :opponent_id => 7)

Match.create!(:tournament_id => 3, :team_id => 6, :date => "2013-07-27 19:00:00", :venue => "Kingston", :match_type => "league", :opponent_id => 13)
Match.create!(:tournament_id => 3, :team_id => 6, :date => "2013-07-28 19:00:00", :venue => "Kingston", :match_type => "league", :opponent_id => 13)
Match.create!(:tournament_id => 3, :team_id => 6, :date => "2013-07-29 19:00:00", :venue => "Kingston", :match_type => "semifinal", :opponent_id => 13)
Match.create!(:tournament_id => 3, :team_id => 6, :date => "2013-07-30 19:00:00", :venue => "Kingston", :match_type => "final", :opponent_id => 13)
