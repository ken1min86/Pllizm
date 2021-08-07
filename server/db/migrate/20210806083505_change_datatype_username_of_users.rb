class ChangeDatatypeUsernameOfUsers < ActiveRecord::Migration[6.1]
  def change
    change_column :users, :name, :string, limit: 50, null: false
  end
end
