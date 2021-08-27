class CurrentUserRefract < ApplicationRecord
  acts_as_paranoid

  belongs_to :user
  belongs_to :refracted_post, class_name: 'Post', foreign_key: 'post_id'

  validates :user_id,           presence: true
  validates :performed_refract, inclusion: { in: [true, false] }
  validates :category,          inclusion: { in: ['like', 'reply'] }
end
