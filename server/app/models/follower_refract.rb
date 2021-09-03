class FollowerRefract < ApplicationRecord
  belongs_to :user
  belongs_to :follower,       class_name: 'User', foreign_key: 'follower_id'
  belongs_to :refracted_post, class_name: 'Post', foreign_key: 'post_id'

  validates :user_id,     presence: true
  validates :follower_id, presence: true
  validates :post_id,     presence: true
  validates :category,    inclusion: { in: ['like', 'reply'] }

  def self.create_follower_refract_when_refarced_liked_post(current_user, refracted_follower, post)
    FollowerRefract.create(
      user_id: refracted_follower.id,
      follower_id: current_user.id,
      post_id: post.id,
      category: 'like',
    )
  end

  def self.create_follower_refract_when_refarced_replied_post(current_user, refracted_follower, post)
    FollowerRefract.create(
      user_id: refracted_follower.id,
      follower_id: current_user.id,
      post_id: post.id,
      category: 'reply',
    )
  end
end
