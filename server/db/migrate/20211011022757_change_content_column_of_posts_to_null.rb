class ChangeContentColumnOfPostsToNull < ActiveRecord::Migration[6.1]
  def up
    change_column_null :posts, :content, true
  end

  def down
    change_column_null :posts, :content, false
  end
end
