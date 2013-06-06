class Team < ActiveRecord::Base
  attr_accessible :name

  has_many :matches

  def abbrev
    words = self.name.split(' ')
    words.length == 1 ? self.name.first(3) : words.collect { |w| w.first }.join
  end
end
