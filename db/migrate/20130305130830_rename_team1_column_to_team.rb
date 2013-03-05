class RenameTeam1ColumnToTeam < ActiveRecord::Migration
  def up
    rename_column :matches, :team1_id, :team
  end

  def down
    rename_column :matches, :team, :team1_id
  end
end
