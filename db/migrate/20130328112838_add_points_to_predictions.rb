class AddPointsToPredictions < ActiveRecord::Migration
  def change
    add_column :predictions, :points, :integer, :default => 0
    remove_column :users, :points
  end
end
