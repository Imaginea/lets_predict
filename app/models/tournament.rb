class Tournament < ActiveRecord::Base
  attr_accessible :end_date, :name, :sport, :start_date, :notified

  has_many :matches, :dependent => :destroy
  has_many :predictions

  validates :name, :presence => true
  validates :start_date, :end_date , :presence => true
  validate :start_date_not_in_future
  validate :start_date_before_end_date
  validates :name, :uniqueness => true

  scope :in_range, lambda { |from, to|  where('start_date < ? AND end_date > ?', from, to) }

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
    self.in_range(today+7, today-2)
  end

  def self.active_tournaments
    today = Date.today
    self.in_range(today, today)
  end

  def self.past_tournaments
    today = Date.today
    self.where("end_date <= ?", today-2).order('end_date DESC')
  end

  # returns true if there's an active/ongoing tournament
  def self.any_running?
    matches_sql = <<-SQL
      SELECT M.tournament_id, MAX(M.date) AS last_match_date, MIN(M.date) AS first_match_date
      FROM matches M
      GROUP BY M.tournament_id
    SQL

    self.joins("INNER JOIN (#{matches_sql}) M ON M.tournament_id = tournaments.id").
      where("M.first_match_date <= ? AND M.last_match_date >= ?", Date.today, Date.today).
      count > 0
  end

  def last_league_match
    @last_league_match ||= self.matches.leagues.order('date DESC').limit(1).first
  end

  def predictions_closed?
    first_non_league_match.date < Time.now.utc
  end

  def waiting_for_non_leagues?
    last_league_match.date <= Time.now.utc && first_non_league_match.date > Time.now.utc
  end

  def matches_count
    @matches_cnt ||= self.matches.count
  end

  def first_match
    self.matches.order('date').first
  end

  def recently_completed_match
    self.matches.includes(:team, :opponent).where('date < ?', Time.now.utc).last
  end

  def last_updated_match
    self.matches.includes(:team, :opponent).
      where('date < ? AND winner_id is NOT NULL', Time.now.utc).
      order('date DESC').first
  end

  def next_match
    self.matches.includes(:team, :opponent).
      where('date > ?',Time.now.utc).
      order('date').first
  end

  def current_match
    self.matches.includes(:team, :opponent).
      where('date < ? AND winner_id IS NULL', Time.now.utc).
      order('date DESC').first
  end

  def first_non_league_match
    self.matches.non_leagues.order('date').first
  end

  def started?
    self.first_match.date <= Time.now.utc
  end

  def last_match
    self.matches.order('date').last
  end

  def finished?
    self.last_match.date < Time.now.utc
  end

  def non_leagues_started?
    self.first_non_league_match.date <= Time.now.utc
  end

  def completed_matches_count
    match_time = 5.hours
    self.matches.where('date < ?', Time.now.utc - match_time).count
  end

  def matches_to_update
    self.matches.past.where('winner_id IS NULL').order("date").includes(:team,:opponent)
  end

  def all_matches
    @matches ||= self.matches.includes(:team, :opponent).order('date').to_a
  end

  def categorize_matches_for_statistics
    older, recent, remaining = [[],[],[]]
    today = Time.now.to_date

    all_matches.each do |m|
      match_day = m.date.localtime.to_date
      if match_day < today - 2.days
        older << m
      elsif match_day <= today && m.date.localtime <= Time.now
        recent << m
      else
        remaining << m
      end
    end
    [older, recent, remaining]
  end

  def categorize_matches_for_predict
    old, todays, remaining = [[],[],[]]
    today = Time.now.to_date

    all_matches.each do |m|
      match_day = m.date.localtime.to_date
      if match_day < today
        old << m
      elsif match_day == today
        todays << m
      else
        remaining << m
      end
    end
    [old, todays, remaining]
  end

  def leaderboard_users(loc = nil)
    loc_conds = "AND location = '#{loc}'" if loc.present?
    @leaderboard_users ||= self.predictions.
      joins(:user).
      where("predicted_team_id IS NOT NULL #{loc_conds}").
      group('users.id, fullname, location').
      order('sum(points) DESC,fullname').
      select('users.id, fullname, location, sum(points) as total_points, count(predicted_team_id) as matches_predicted')
  end

  def connected_users_in_group(group)
    uids = group.connected_members_ids
    con_users ||= User.joins("left outer join predictions on users.id = predictions.user_id AND predictions.tournament_id = #{self.id}").
      where('users.id IN (?)', uids).
      group('users.id, fullname').
      order('sum(points) DESC,fullname').
      select('users.id, fullname, location, sum(points) as total_points')
    con_users.sort_by{|x| x.total_points.to_i}.reverse
  end

  def prediction_accuracy_by_user
    @correct_predictions ||= self.predictions.joins(:match).
      where('predicted_team_id IS NOT NULL').
      where('matches.winner_id IS NOT NULL').
      group('user_id').
      select('COUNT(CASE WHEN predicted_team_id = winner_id THEN 1 ELSE NULL END) AS correct_predictions, COUNT(*) AS predicted, user_id').
      group_by(&:user_id)
  end

  def toppers
    max = self.predictions.group('user_id').
      order('sum(points) DESC').select('sum(points) as max_points').limit(1)
    max = max.first.max_points

    self.predictions.joins(:user).
      where('predicted_team_id IS NOT NULL').
      group('users.id, fullname, location').
      having("sum(points) = #{max}").
      order('sum(points) DESC,fullname').
      select('fullname, location, sum(points) as total_points')
  end

  def total_predictors
    self.predictions.where('predicted_team_id IS NOT NULL').count("distinct(user_id)")
  end

  def predictors
    @predictors ||= self.predictions.
      joins(:user).
      where('predicted_team_id IS NOT NULL').
      group('fullname,login,location').
      order('fullname').
      select('fullname, location, count(predicted_team_id) as matches_predicted').to_a
  end

  # find locations of all players for the current tournament
  # used for filter options in leaderbord view
  def predictor_locations
    @predictor_locations ||= self.predictions.joins(:user).
      where('predicted_team_id IS NOT NULL').
      group('location').pluck(:location)
  end

  def inactive_users
    date_range = (Date.today-5.days .. Date.today)
    inactive_predictions = self.matches.joins(:predictions).where(:date => date_range).where('predicted_team_id IS NULL').select('user_id').uniq
    inactive_user_ids = inactive_predictions.collect{|p| p.user_id}
  end

  def first_unpredicted_match(u_id)
    m = self.matches.joins(:predictions).
      where("date > '#{Time.now.utc}'").
      where('predictions.user_id' => u_id).where('predictions.predicted_team_id IS NULL').
      order('date').first
    m || self.matches.order('date').first
  end

  def teams
    team_ids = self.matches.leagues.collect{|m| [m.team_id,m.opponent_id]}.flatten.uniq
    teams = Team.where(:id => team_ids)
  end
end
