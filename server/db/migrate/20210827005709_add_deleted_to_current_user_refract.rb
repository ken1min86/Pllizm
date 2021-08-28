class AddDeletedToCurrentUserRefract < ActiveRecord::Migration[6.1]
  def change
    add_column :current_user_refracts, :deleted_at, :datetime
    add_index :current_user_refracts, :deleted_at
  end
end
