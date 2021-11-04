class CreateCurrentUserRefracts < ActiveRecord::Migration[6.1]
  def change
    create_table :current_user_refracts do |t|
      t.references :user, index: true, null: false
      t.boolean :performed_refract, null: false
      t.string :post_id, index: true
      t.string :category

      t.timestamps
    end

    add_foreign_key :current_user_refracts, :users
    add_foreign_key :current_user_refracts, :posts, column: :post_id
  end
end
