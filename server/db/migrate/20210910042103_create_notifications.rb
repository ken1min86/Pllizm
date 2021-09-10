class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.bigint :notify_user_id, index: true, null: false
      t.bigint :notified_user_id, index: true, null: false
      t.string :action, null: false
      t.string :post_id, index: true, null: false
      t.boolean :is_checked, null: false, default: false

      t.timestamps
    end

    add_foreign_key :notifications, :users, column: :notify_user_id
    add_foreign_key :notifications, :users, column: :notified_user_id
    add_foreign_key :notifications, :posts, column: :post_id
  end
end
