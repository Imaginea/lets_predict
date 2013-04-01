class Match < ActiveRecord::Base
  attr_accessible :date, :match_type, :team_id, :opponent_id, :tournament_id, :venue, :winner_id

  belongs_to :tournament
  belongs_to :team
  belongs_to :opponent, :class_name => 'Team'
  belongs_to :winner, :class_name => 'Team'

  VALID_MATCH_TYPES = %w(league semifinal final qualifier eliminator)

  validates :date, :presence => true
  validates :match_type, :inclusion => { :in => VALID_MATCH_TYPES, :message => "Not a valid match type" }
  validates :team_id, :opponent_id, :presence => true , :if => :league_match?

  scope :league_matches, where(:match_type => "league")
  scope :non_league_matches, where(:match_type => VALID_MATCH_TYPES - ['league']).order('id')

  def success_points
    case self.match_type.to_sym
    when :league
      2
    when :semifinal, :qualifier, :eliminator
      4
    when :final
      8
    end
  end

  private 

  def league_match? 
    match_type == "league"
  end  
end
