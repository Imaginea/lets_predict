class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.references :tournament
      t.references :team
 
      t.datetime :date
      t.string :venue
      t.string :match_type
      t.integer :opponent_id
      t.integer :winner_id

      t.timestamps
    end
  end
end
