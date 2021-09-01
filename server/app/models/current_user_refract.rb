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

  def self.get_target_times_of_refract(current_user)
    target_time_from = nil
    target_time_to = nil
    if CurrentUserRefract.with_deleted.where(user_id: current_user.id).length >= 2
      new_refract, old_refract = CurrentUserRefract.get_latest_two_refracts(current_user)
      target_time_from = old_refract.created_at
      target_time_to = new_refract.created_at
    else
      new_refract = CurrentUserRefract.find_by(user_id: current_user.id)
      target_time_from = current_user.created_at
      target_time_to = new_refract.created_at
    end
    [target_time_from, target_time_to]
  end
end
