require 'net/ldap'

module LdapAuth

  def ldap_authenticate(username, password)
    ldap = Net::LDAP.new
    ldap.host = "ldap.pramati.com"
    ldap.authenticate("uid=#{username}, ou=Employees, dc=pramati, dc=com", password)
    ldap.bind
  end

  def get_ldap_entities(username)
    ldap = Net::LDAP.new
    ldap.host = "ldap.pramati.com"
    filter = Net::LDAP::Filter.eq("uid", username)
    treebase = "ou=Employees, dc=pramati, dc=com"


    entities = {}
    
    ldap.search(:base => treebase, :filter => filter) do |entry|
      entities[:fullname] = entry[:cn].first
      entities[:email] = entry[:mail].first
    end
    entities
  end
end
