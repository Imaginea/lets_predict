class AddNotifiedToTournaments < ActiveRecord::Migration
  def change
    add_column :tournaments, :notified, :boolean, :default => false
  end
end
