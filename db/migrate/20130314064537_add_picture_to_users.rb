class AddPictureToUsers < ActiveRecord::Migration
  def up
    add_column :users, :picture, :string
  end

  def down
    remove_column :users, :picture
  end
end

