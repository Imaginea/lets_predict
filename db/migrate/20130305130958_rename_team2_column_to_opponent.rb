class RenameTeam2ColumnToOpponent < ActiveRecord::Migration
  def up
    rename_column :matches, :team2_id, :opponent
  end

  def down
    rename_column :matches, :opponent, :team2_id
  end
end
