require 'net_ldap_auth'

class User < ActiveRecord::Base
  extend Ldapauth
  
  attr_accessible :fullname, :login, :points, :email

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

  private
  def get_ldap_params
    details = User.get_ldap_entities(login)
    self.update_attributes(details)
  end
end

