class Prediction < ActiveRecord::Base
  attr_accessible :match_id, :predicted_team_id, :user_id, :tournament_id

  belongs_to :user
  belongs_to :predicted_team, :class_name => "Team"
  belongs_to :tournament
  belongs_to :match

  validates :user_id, :match_id, :tournament_id, :presence => true
  validates :match_id, :uniqueness => { :scope => :user_id }
end
