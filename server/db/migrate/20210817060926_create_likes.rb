class CreateLikes < ActiveRecord::Migration[6.1]
  def change
    create_table :likes do |t|
      t.references :user, index: true, null: false
      t.string :post_id, index: true, null: false

      t.timestamps
    end

    add_index :likes, [:user_id, :post_id], unique: true
    add_foreign_key :likes, :users
    add_foreign_key :likes, :posts, column: :post_id
  end
end
