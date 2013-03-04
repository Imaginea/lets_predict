class Match < ActiveRecord::Base
  attr_accessible :date, :match_type, :team1_id, :team2_id, :tournament_id, :venue, :winner_id

  belongs_to :tournament
  has_and_belongs_to_many :teams
  has_and_belongs_to_many :predictions

  validates :date, :presence => true
  validates :match_type, :inclusion => { :in => %w(league semifinal final), :message => "Not a valid match type" }
  validates :team1_id, :presence => true , :if => :league_match?
  validates :team2_id, :presence => true , :if => :league_match?

  private 

  def league_match? 
    match_type == "league"
  end

end
