class ChangeColumnToUser < ActiveRecord::Migration[6.1]
  def change
    def up
      change_column :users, :email, :string, presence: true
      change_column :users, :uid, :string, presence: true
      change_column :users, :name, :string, limit: 50, presence: true
    end

    def down
      change_column :users, :email, :string, null: false
      change_column :users, :uid, :string, null: false
      change_column :users, :name, :string, limit: 50, null: false
    end
  end
end
