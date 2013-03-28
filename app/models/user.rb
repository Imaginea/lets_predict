require 'ldap_auth'

class User < ActiveRecord::Base
  extend LdapAuth
  
  attr_accessible :fullname, :login, :points, :email, :picture

  mount_uploader :picture, PictureUploader

  has_many :predictions, :dependent => :destroy

  validates_presence_of :login
  validates_uniqueness_of :login
  
  after_create :get_ldap_params

  def self.authenticate(params)
    if ldap_authenticate(params[:login], params[:password])
      attrs = { :login => params[:login] }
      user = User.find_or_create_by_login(attrs)
    end
  end
  
  def predicted_teams_by_match_id
    ps = self.predictions.where('predicted_team_id is NOT NULL')
    team_ids = ps.collect(&:predicted_team_id)
    teams = Team.where(:id => team_ids).group_by(&:id)

    ps.inject({}) do |result, p|
      team = teams[p.predicted_team_id].first
      result.update(p.match_id => [team.id, team.name])
    end
  end

  def has_predicted?(match_id)   
    match = self.predictions.find_by_match_id(match_id)
    !match.predicted_team_id.nil?
  end 

  def tournament_points(t_id)
    predictions.where(:tournament_id => t_id).sum(:points)
  end

  private
  
  def get_ldap_params
    details = User.get_ldap_entities(login)
    self.update_attributes(details)
  end
end

