require 'ldap_auth'

class User < ActiveRecord::Base
  extend LdapAuth
  
  attr_accessible :name, :fullname, :login, :points, :email, :picture, :location
  mount_uploader :picture, PictureUploader

  has_many :predictions, :dependent => :destroy
  has_one :custom_group
  has_many :group_connections, :dependent => :destroy

  validates_presence_of :login
  validates_uniqueness_of :login
  
  after_create :get_ldap_params

  VALID_LOCATIONS = ['Chennai', 'Bangalore', 'Hyderabad']
  ADMINS = ['suprajas', 'sathishn', 'kalyanc']

  def self.authenticate(params)
    if ldap_authenticate(params[:login], params[:password])
      attrs = { :login => params[:login] }
      user = User.find_or_create_by_login(attrs)
    end
  end

  # Find all users who are part of the current tournament
  # and having an unpredicted match coming up shortly.
  # Use it in cron(runs every 5mins) to send out remainder emails.
  #
  # Returns the User scope which can be chained further, like:
  # User.with_immediate_unpredicted_match.pluck(:email)
  #
  def self.with_immediate_unpredicted_match
    now = Time.now.utc
    User.joins(:predictions => [:tournament, :match]).
      where(:tournaments => "start_date <= #{Date.today} AND end_date >= #{Date.today}").
      where(:matches     => "date > #{now} AND date <= #{now + 2.hours}").
      where(:predictions => "predicted_team_id IS NULL")
  end

  def location_invalid?
    loc = self.location.to_s.strip
    !VALID_LOCATIONS.include?(loc)
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

  def connection_for_group(group_id)
    self.group_connections.find_by_custom_group_id(group_id)
  end

  def reached_group_limit?
    self.group_connections.requested.count >= 2
  end

  def create_my_group(name)
    cg = self.build_custom_group(:group_name => name)
    # connect to my own group
    cg.group_connections.build(:user_id => self.id, :status => 'own')
    cg.save
  end

  def delete_my_group
    cg = self.custom_group
    status = cg.try(:destroy)
    to_emails = cg.members.requested.collect { |gc| gc.user.email }
    UserMailer.delay.group_deletion(cg.group_name, to_emails) if status && to_emails.any?
    status
  end

  def invitations
    GroupConnection.pending_connections(self)
  end

  private
  
  def get_ldap_params
    details = User.get_ldap_entities(login)
    self.update_attributes(details)
  end
end
