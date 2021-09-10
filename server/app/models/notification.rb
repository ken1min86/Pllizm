class Notification < ApplicationRecord
  belongs_to :notify_user,   class_name: 'User', foreign_key: 'notify_user_id'
  belongs_to :notified_user, class_name: 'User', foreign_key: 'notified_user_id'
  belongs_to :notified_post, class_name: 'Post', foreign_key: 'post_id'

  validates :notify_user_id,   presence: true
  validates :notified_user_id, presence: true
  validates :action,           inclusion: { in: ['like', 'reply', 'request', 'accept', 'refract'] }
  validates :is_checked,       inclusion: { in: [true, false] }
end
