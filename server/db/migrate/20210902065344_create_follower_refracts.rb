class CreateFollowerRefracts < ActiveRecord::Migration[6.1]
  def change
    create_table :follower_refracts do |t|
      t.references :user, index: true, null: false
      t.bigint :follower_id, index: true, null: false
      t.string :post_id, index: true, null: false
      t.string :category, null: false

      t.timestamps
    end

    add_foreign_key :follower_refracts, :users
    add_foreign_key :follower_refracts, :users, column: :follower_id
    add_foreign_key :follower_refracts, :posts, column: :post_id
  end
end
