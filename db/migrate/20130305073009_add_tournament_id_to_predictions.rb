class AddTournamentIdToPredictions < ActiveRecord::Migration
  def change
    add_column :predictions, :tournament_id, :string
  end
end
