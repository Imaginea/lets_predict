class Tournament < ActiveRecord::Base
  attr_accessible :end_date, :name, :sport, :start_date

  has_many :matches, :dependent => :destroy
  has_many :predictions

  validates :name, :presence => true
  validates :start_date, :end_date , :presence => true
  validate :start_date_not_in_future
  validate :start_date_before_end_date
  validates :name, :uniqueness => true

  def start_date_before_end_date
    errors.add(:start_date, "must be before end date") unless
       self.start_date < self.end_date
  end

  def start_date_not_in_future
    errors.add(:start_date, "Must be a date in future ") unless
       self.start_date > Date.today
  end

  def self.current_tournaments
    today = Date.today
    where("start_date < (?) AND end_date > (?)", today+30, today+2).to_a
  end

  def last_league_match
    @last_league_match ||= self.matches.leagues.order('date DESC').limit(1).first
  end

  def predictions_closed?
    last_league_match.date < Time.now.utc
  end

  def matches_count
    @matches_cnt ||= self.matches.count
  end

  def started?
    self.start_date < Date.today
  end

  def completed_matches_count
    match_time = 3.hours
    self.matches.where('date < ?', Time.now.utc + match_time).count
  end

  def leaderboard_users
    @leaderboard_users ||= self.predictions.
      joins(:user).
      where('predicted_team_id IS NOT NULL').
      group('users.id, fullname, location').
      order('sum(points) DESC').
      select('users.id, fullname, location, sum(points) as total_points, count(predicted_team_id) as matches_predicted')
  end

  def total_predictors
   self.predictions.count("distinct(user_id)")
  end

  def predictors
    @predictors ||= self.predictions.
      joins(:user).
      where('predicted_team_id IS NOT NULL').
      group('fullname,location').
      select('fullname, location, count(predicted_team_id) as matches_predicted').to_a
  end

  def first_unpredicted_match(u_id)
    m = self.matches.joins(:predictions).
      where("date > '#{Time.now.utc}'").
      where('predictions.user_id' => u_id).where('predictions.predicted_team_id IS NULL').
      order('date').first
    m || self.matches.order('date').first
  end
end
