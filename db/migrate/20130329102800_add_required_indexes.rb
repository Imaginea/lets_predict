class AddRequiredIndexes < ActiveRecord::Migration
  def change
    add_index :users, :login

    add_index :matches, :tournament_id
    add_index :matches, [:tournament_id, :match_type]
    add_index :matches, [:tournament_id, :date]

    add_index :predictions, :tournament_id
    add_index :predictions, :user_id
    add_index :predictions, :match_id
    add_index :predictions, [:tournament_id, :predicted_team_id]
    add_index :predictions, [:match_id, :predicted_team_id]

    add_index :tournaments, [:start_date, :end_date]
  end
end
