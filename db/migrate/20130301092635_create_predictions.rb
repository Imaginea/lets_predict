class CreatePredictions < ActiveRecord::Migration
  def change
    create_table :predictions do |t|
      t.references :user
      t.references :team
      t.references :match

      t.integer :match_id
      t.integer :user_id
      t.integer :predicted_team_id

      t.timestamps
    end
  end
end
