class Like < ApplicationRecord
  belongs_to :user
  belongs_to :liked_post, class_name: 'Post', foreign_key: 'post_id'

  validates :user_id,   presence: true
  validates :post_id,   presence: true, uniqueness: { scope: :user_id }
end
