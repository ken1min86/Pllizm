class AddUseridToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :userid, :string, :limit => 15
    add_index :users, :userid, unique: true
  end
end
