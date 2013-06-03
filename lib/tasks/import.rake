namespace :db do

  desc "Imports the match fixtures from CSV into matches table"

  task :import_matches => :environment do
    require 'csv'

    imported_count = 0
    Match.transaction do
      CSV.foreach("db/matches.csv") do |row|
        row = row.first.split(';') if row.first.include?(';')
        match = Match.new(
          :date => Time.strptime(row[0], "%m/%d/%Y %H:%M").to_time,
          :tournament_id => row[1],
          :venue => row[2],
          :match_type => row[3],
          :team_id => row[4],
          :opponent_id => row[5],
          :winner_id => row[6]
        )

        if match.valid?
          match.save
          imported_count += 1
        else
          puts "Validation failed while importing row: #{row.inspect}"
          puts "Match object: #{match.attributes.inspect}"
          raise "Error: #{match.errors.full_messages.inspect}"
        end
      end # foreach
    end # transaction
    puts "Done. #{imported_count} matches imported."
  end
end
