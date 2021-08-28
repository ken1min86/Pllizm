class CurrentUserRefract < ApplicationRecord
  acts_as_paranoid

  belongs_to :user
  belongs_to :refracted_post, class_name: 'Post', foreign_key: 'post_id', optional: true

  validates :user_id,           presence: true
  validates :performed_refract, inclusion: { in: [true, false] }
  validates :category,          inclusion: { in: ['like', 'reply'] }, allow_nil: true
  validates :refracted_post,    presence: true, if: :post_id?

  def self.get_latest_two_refracts(current_user)
    CurrentUserRefract.with_deleted.where(user_id: current_user.id).order('created_at DESC').limit(2)
  end
end
