class Prediction < ActiveRecord::Base
  attr_accessible :match_id, :predicted_team_id, :user_id, :tournament_id

  belongs_to :user
  belongs_to :team
  belongs_to :tournament
  belongs_to :match

end
