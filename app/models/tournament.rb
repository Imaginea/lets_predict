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
    where("start_date < (?) AND end_date > (?)", today+30, today+2)
  end

  def predictions_closed?
    self.start_date <= Date.today
  end

  def matches_count
    @matches_cnt ||= self.matches.count
  end

  def completed_matches_count
    match_time = 3.hours
    self.matches.where('date < ?', Time.now.utc + match_time).count
  end

  def leaderboard_users
    @leaderboard_users ||= self.predictions.
      joins(:user).
      where('predicted_team_id IS NOT NULL').
      group('users.id, fullname, email').
      order('sum(points) DESC').
      select('users.id, fullname, email, sum(points) as total_points, count(predicted_team_id) as matches_predicted')
  end
end
