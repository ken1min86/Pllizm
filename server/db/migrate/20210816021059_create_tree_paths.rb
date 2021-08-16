class CreateTreePaths < ActiveRecord::Migration[6.1]
  def change
    create_table :tree_paths do |t|
      t.string :ancestor, index: true, null: false
      t.string :descendant, index: true, null: false
      t.integer :depth, null: false
      t.timestamps

      t.index [:ancestor, :descendant], unique: true
    end

    add_foreign_key :tree_paths, :posts, column: :ancestor
    add_foreign_key :tree_paths, :posts, column: :descendant
  end
end
