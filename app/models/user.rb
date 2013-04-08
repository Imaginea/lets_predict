require 'ldap_auth'

class User < ActiveRecord::Base
  extend LdapAuth
  
  attr_accessible :fullname, :login, :points, :email, :picture, :location

  mount_uploader :picture, PictureUploader

  has_many :predictions, :dependent => :destroy

  validates_presence_of :login
  validates_uniqueness_of :login
  
  after_create :get_ldap_params

  INVALID_LOCATIONS = ['', 'default', 'Begumpet']
  ADMINS = ['suprajas', 'sathishn']

  def self.authenticate(params)
    if ldap_authenticate(params[:login], params[:password])
      attrs = { :login => params[:login] }
      user = User.find_or_create_by_login(attrs)
    end
  end

  def self.valid_locations
    all_locs = self.select('distinct(location)').collect { |u| u.location.to_s } 
    all_locs - INVALID_LOCATIONS
  end
  
  def location_invalid?
    loc = self.location.to_s.strip
    INVALID_LOCATIONS.include?(loc)
  end

  def predicted_teams_by_match_id
    ps = self.predictions.where('predicted_team_id is NOT NULL').to_a
    team_ids = ps.collect(&:predicted_team_id)
    teams = Team.where(:id => team_ids).group_by(&:id)

    ps.inject({}) do |result, p|
      team = teams[p.predicted_team_id].first
      result.update(p.match_id => [team.id, team.name, p.points])
    end
  end

  def has_predicted?(match_id)   
    match = self.predictions.find_by_match_id(match_id)
    !match.predicted_team_id.nil?
  end

  def prediction_for(match)
    self.predictions.where(:match_id => match.id).first
  end

  def total_points_for(t_id)
    predictions.where(:tournament_id => t_id).sum(:points)
  end

  def predictions_count(t_id)
    self.predictions.where(:tournament_id => t_id).where('predicted_team_id IS NOT NULL').count
  end

  def rank_for(t_id)
    ps = Prediction.where(:tournament_id => t_id).
      group(:user_id).
      select('user_id, sum(points) as total_points').
      order('total_points DESC').to_a
    rank = 1
    ps_grouped = ps.group_by(&:total_points)

    ps_grouped.each do |pts, ps_arr|
      break if ps_arr.any? { |p| p.user_id == self.id }
      rank += 1
    end
    rank
  end
  
  def predicted_teams_sorted(t_id)
    self.predictions.joins(:predicted_team).
      where(:tournament_id => t_id).where('predicted_team_id IS NOT NULL').
      group('teams.id,teams.name').order('count(predictions.id) DESC').
      select('teams.id,teams.name,count(predictions.id) as count')
  end

  def admin?
    ADMINS.include? self.login
  end

  private
  
  def get_ldap_params
    details = User.get_ldap_entities(login)
    self.update_attributes(details)
  end
end

