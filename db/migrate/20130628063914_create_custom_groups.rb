class CreateCustomGroups < ActiveRecord::Migration
  def change
    create_table :custom_groups do |t|
      t.string :group_name
      t.integer :user_id

      t.timestamps
    end
  end
end
