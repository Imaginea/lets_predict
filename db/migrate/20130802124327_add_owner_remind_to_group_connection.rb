class AddOwnerRemindToGroupConnection < ActiveRecord::Migration
  def change
    add_column :group_connections, :owner_remind, :boolean
  end
end
