require 'net/ldap'

module LdapAuth

  def ldap_authenticate(username, password)
    return true if ldap_disabled?

    ldap = Net::LDAP.new
    ldap.host = "ldap.pramati.com"
    ldap.authenticate("uid=#{username}, ou=Employees, dc=pramati, dc=com", password)
    ldap.bind
  end

  def get_ldap_entities(username)
    return {:full.name => 'TestUser', :email => 'testuser@test.com'} if ldap_disabled?

    ldap = Net::LDAP.new
    ldap.host = "ldap.pramati.com"
    filter = Net::LDAP::Filter.eq("uid", username)
    treebase = "ou=Employees, dc=pramati, dc=com"


    entities = {}
    
    ldap.search(:base => treebase, :filter => filter) do |entry|
      entities[:fullname] = entry[:cn].first
      entities[:email] = entry[:mail].first
      entities[:location] = entry[:baselocation].first.match(/l=([a-zA-Z\s\-0-9_]*),.*/).captures.first rescue ''
    end
    entities
  end

  def ldap_disabled?
    ENV['LDAP'] == 'false'
  end
end
