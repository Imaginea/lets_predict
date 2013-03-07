namespace :db do

  desc "Imports a CSV file into an ActiveRecord table"

  task :csv_model_import => :environment do
     require 'csv'

    CSV.foreach("matches.csv") do |row|
      Match.create(
        :date => row[0],
        :tournament_id => row[1],
        :venue => row[2],
        :match_type => row[3],
        :team => row[4],
        :opponent => row[5],
        :winner_id => row[6]
      )
    end
  end
end