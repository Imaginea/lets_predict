class Match < ActiveRecord::Base
  attr_accessible :date, :match_type, :team_id, :opponent_id, :tournament_id, :venue, :winner_id

  belongs_to :tournament
  belongs_to :team
  belongs_to :opponent, :class_name => 'Team'
  belongs_to :winner, :class_name => 'Team'

  validates :date, :presence => true
  validates :match_type, :inclusion => { :in => %w(league semifinal final qualifier eliminator), :message => "Not a valid match type" }
  validates :team_id, :opponent_id, :presence => true , :if => :league_match?

  def self.league_matches
    Match.where(:match_type => "league")
  end

  def self.non_league_matches
    Match.where(:match_type => ["semifinal","final","qualifier","eliminator"])
  end

  private 

  def league_match? 
    match_type == "league"
  end  

end
