class FollowerRefract < ApplicationRecord
  belongs_to :user
  belongs_to :follower,       class_name: 'User', foreign_key: 'follower_id'
  belongs_to :refracted_post, class_name: 'Post', foreign_key: 'post_id'

  validates :user_id,     presence: true
  validates :follower_id, presence: true
  validates :post_id,     presence: true
  validates :category,    inclusion: { in: ['like', 'reply'] }
end
