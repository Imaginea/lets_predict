class Prediction < ActiveRecord::Base
  attr_accessible :match_id, :predicted_team_id, :user_id

  belongs_to :user
  belongs_to :team
  has_and_belongs_to_many :matches

end
