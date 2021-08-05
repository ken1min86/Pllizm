class ChangeNameColumnToUser < ActiveRecord::Migration[6.1]
  def up
    change_column :users, :name, :string, limit: 50, null: true
  end

  def down
    change_column :users, :name, :string, null: false, limit: 50
  end

end
