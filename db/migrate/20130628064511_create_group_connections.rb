class CreateGroupConnections < ActiveRecord::Migration
  def change
    create_table :group_connections do |t|
      t.integer :custom_group_id
      t.integer :user_id
      t.string :status

      t.timestamps
    end
  end
end
