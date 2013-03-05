class Match < ActiveRecord::Base
  attr_accessible :date, :match_type, :team1_id, :team2_id, :tournament_id, :venue, :winner_id

  belongs_to :tournament
  belongs_to :team1, :class_name => 'Team'
  belongs_to :team2, :class_name => 'Team'
  belongs_to :winner, :class_name => 'Team'
  #has_many :predictions


  validates :date, :presence => true
  validates :match_type, :inclusion => { :in => %w(league semifinal final), :message => "Not a valid match type" }
  validates :team1_id, :presence => true , :if => :league_match?
  validates :team2_id, :presence => true , :if => :league_match?

  private 

  def league_match? 
    match_type == "league"
  end

end
