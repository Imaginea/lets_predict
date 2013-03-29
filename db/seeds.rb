# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
Tournament.create!(:name => 'IPL 6', :start_date => '03/04/2013', :end_date => '26/05/2013', :sport => 'Cricket')
['Chennai Super Kings', 'Royal Challengers Bangalore', 'Delhi Daredevils', 'Mumbai Indians', 'Kolkata Knight Riders', 'Rajasthan Royals', 'Kings XI Punjab', 'Pune Warriors', 'Sun Risers Hyderabad'].each do |team_name|
  Team.create!(:name => team_name)
end
