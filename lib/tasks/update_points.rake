namespace :match do

  # Usage:
  # rake match:update_result[1,team]
  # rake match:update_result[1,opponent]
  desc "Update points and winner_id for the corresponding match"
  task :update_result, [:match_id, :winner_type] => :environment do |t, args|
    m_id, w_type = args.match_id.to_i, args.winner_type
    raise "Missing match id or winner type" if m_id.blank? || w_type.blank?
    raise "Winner type should be one of 'team' or 'opponent'" unless ['team', 'opponent'].include?(w_type)

    match = Match.find(m_id)
    winner_id, pts = match.send("#{w_type}_id".to_sym), match.success_points
    match.update_attribute(:winner_id, winner_id)

    preds = Prediction.where(:match_id => m_id, :predicted_team_id => winner_id).to_a
    puts "Updating #{preds.length} correct predictions with #{pts} points..."
    preds.each do |p|
      p.update_attribute(:points, pts)
    end
    puts "Done."
  end
end
