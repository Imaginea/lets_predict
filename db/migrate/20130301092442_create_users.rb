class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :login
      t.string :fullname
      t.integer :points

      t.timestamps
    end
  end
end
