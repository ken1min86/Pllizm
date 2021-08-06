class ChangeUseridColumnToUser < ActiveRecord::Migration[6.1]
  def change
    change_column :users, :userid, :string, limit: 15, null: false
  end
end
