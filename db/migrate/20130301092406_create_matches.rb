class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.references :tournament
      t.references :team
            
      t.datetime :date
      t.integer :tournament_id
      t.string :venue
      t.string :match_type
      t.integer :team1_id
      t.integer :team2_id
      t.integer :winner_id

      t.timestamps
    end
  end
end
