class CreateCustomGroups < ActiveRecord::Migration
  def change
    create_table :custom_groups do |t|
      t.string :group_name
      t.integer :user_id
      t.integer :total_members, :default => 1

      t.timestamps
    end

    add_index :custom_groups, :user_id, :unique => true
  end
end
