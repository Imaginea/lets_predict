class User < ActiveRecord::Base
  attr_accessible :fullname, :login, :points

  has_many :predictions
end
