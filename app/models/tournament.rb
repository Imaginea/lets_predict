class Tournament < ActiveRecord::Base
  attr_accessible :end_date, :name, :sport, :start_date

  has_many :matches, :dependent => :destroy

  validates :name, :presence => true
  validates :start_date, :end_date , :presence => true
  validate :start_date_not_in_future
  validate :start_date_before_end_date
  validates :name, :uniqueness => true

  def start_date_before_end_date
    errors.add(:start_date, "must be before end date") unless
       self.start_date < self.end_date
  end

  def start_date_not_in_future
    errors.add(:start_date, "Must be a date in future ") unless
       self.start_date > Date.today
  end

end
