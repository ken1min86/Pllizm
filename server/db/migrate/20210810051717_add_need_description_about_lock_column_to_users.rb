class AddNeedDescriptionAboutLockColumnToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :need_description_about_lock, :boolean, null: false, default: true
  end
end
