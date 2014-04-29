class Match < ActiveRecord::Base
  attr_accessible :date, :match_type, :team_id, :opponent_id, :tournament_id, :venue, :winner_id

  belongs_to :tournament
  belongs_to :team
  belongs_to :opponent, :class_name => 'Team'
  belongs_to :winner, :class_name => 'Team'
  has_many :predictions

  VALID_MATCH_TYPES = %w(league semifinal final qualifier eliminator)

  validates :date, :presence => true
  validates :match_type, :inclusion => { :in => VALID_MATCH_TYPES, :message => "Not a valid match type" }
  validates :team_id, :opponent_id, :presence => true , :if => :league_match?

  scope :leagues, where(:match_type => "league")
  scope :non_leagues, where(:match_type => VALID_MATCH_TYPES - ['league']).order('id')
  scope :past, lambda { where('date < ?', Time.now.utc) }

  def success_points
    case self.match_type.to_sym
    when :league
      3
    when :semifinal, :qualifier, :eliminator
      6
    when :final
      9
    end
  end

  def failure_points
    -(self.success_points/3)
  end

  def can_predict?
    self.date > Time.now.utc
  end

  def abbrev_team_names
    abbrvs = [self.team, self.opponent].compact.collect(&:abbrev)
    abbrvs.empty? ? ['TBD'] * 2 : abbrvs
  end

  def correct_predictions
    @predictions ||= self.predictions.joins(:user).where(:points => self.success_points).select('fullname,location')
  end

  def predictors_count
    @predictors_count ||= self.predictions.where('predicted_team_id IS NOT NULL').count
  end

  def predictors_count_for(team)
    self.predictions.where('predicted_team_id = ?', team.id).count
  end

  private 

  def league_match? 
    match_type == "league"
  end
end

