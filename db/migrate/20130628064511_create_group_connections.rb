class CreateGroupConnections < ActiveRecord::Migration
  def change
    create_table :group_connections do |t|
      t.integer :custom_group_id
      t.integer :user_id
      t.string :status, :default => 'pending'
      t.boolean :owner_remind, :default => false

      t.timestamps
    end

    add_index :group_connections, :custom_group_id
  end
end
