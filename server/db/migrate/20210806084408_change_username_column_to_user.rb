class ChangeUsernameColumnToUser < ActiveRecord::Migration[6.1]
  def change
    change_column :users, :username, :string, limit: 50, null: false
  end
end
