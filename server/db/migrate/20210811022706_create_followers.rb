class CreateFollowers < ActiveRecord::Migration[6.1]
  def change
    create_table :followers do |t|
      t.bigint :followed_by, index: true
      t.bigint :follow_to, index: true

      t.timestamps

      t.index [:followed_by, :follow_to], unique: true
    end
    add_foreign_key :followers, :users, column: :followed_by
    add_foreign_key :followers, :users, column: :follow_to
  end
end
