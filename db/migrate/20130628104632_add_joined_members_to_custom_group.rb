class AddJoinedMembersToCustomGroup < ActiveRecord::Migration
  def change
    add_column :custom_groups, :total_members, :integer
  end
end
