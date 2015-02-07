namespace :db do

  # accepts :tname -> tournament name and :sport -> sport name, defaulted to cricket
  # Usage: 
  # ======
  # rake db:import_tournament['Champions League 2013']
  # rake db:import_tournament['EPL 2013','Football']
  #
  desc "Creates a tournament and imports the match fixtures from db/matches.csv"
  task :import_tournament, [:tname, :sport] => :environment do |t, args|
    require 'csv'
    tname = args.tname
    sport = args.sport || 'Cricket'
    raise "Tournament name is required to import matches" if tname.blank?

    rows = CSV.read('db/matches.csv', :col_sep => ';')
    first_match_time = Time.strptime(rows.first[0], "%m/%d/%Y %H:%M").to_date
    last_match_time  = Time.strptime(rows.last[0], "%m/%d/%Y %H:%M").to_date
    t = Tournament.create!(
      :name => tname, :start_date => first_match_time,
      :end_date => last_match_time, :sport => sport
    )

    imported_count = 0
    cached_teams = Team.all.group_by(&:name)
    puts "Trying to import #{rows.length} matches..."

    Match.transaction do
      rows.each do |row|
        tname, oname = row[3], row[4] # team name, opponent name
        team = tname && (cached_teams[tname] ||= [Team.create!(:name => tname)]).first
        oppnt = oname && (cached_teams[oname] ||= [Team.create!(:name => oname)]).first

        match = Match.new(
          :date => Time.strptime(row[0], "%m/%d/%Y %H:%M").to_time,
          :tournament_id => t.id,
          :venue => row[1],
          :match_type => row[2],
          :team_id => team.try(:id),
          :opponent_id => oppnt.try(:id)
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
