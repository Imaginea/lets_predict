# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
Tournament.create!(:name => 'IPL 6', :start_date => '03/04/2013', :end_date => '26/05/2013', :sport => 'Cricket')
['Kolkata Knight Riders', 'Delhi Daredevils', 'Sun Risers Hyderabad', 'Pune Warriors', 'Rajasthan Royals', 'Chennai Super Kings', 'Kings XI Punjab', 'Royal Challengers Bangalore', 'Mumbai Indians'].each do |team_name|
  Team.create!(:name => team_name)
end
