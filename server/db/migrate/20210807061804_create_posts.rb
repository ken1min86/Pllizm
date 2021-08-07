class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts, id: :string do |t|
      t.references :user, foreign_key: true
      t.string :content, null: false, limit: 140
      t.string :image
      t.references :icon, foreign_key: true
      t.boolean :is_locked, null: false, default: false
      t.datetime :deleted_at
      t.timestamps
    end

    add_index :posts, :deleted_at
  end
end
