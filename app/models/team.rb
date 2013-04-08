class Team < ActiveRecord::Base
  attr_accessible :name

  has_many :matches

  def abbrev
    self.name.split(' ').collect { |word| word.first }.join
  end
end
