class AddCheckRequiredColumnToPost < ActiveRecord::Migration[6.1]
  def change
    add_check_constraint :posts, "content IS NOT NULL OR image IS NOT NULL ", name: "required_check"
  end
end
