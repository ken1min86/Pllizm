class Notification < ApplicationRecord
  belongs_to :notify_user,   class_name: 'User', foreign_key: 'notify_user_id'
  belongs_to :notified_user, class_name: 'User', foreign_key: 'notified_user_id'
  belongs_to :notified_post, class_name: 'Post', foreign_key: 'post_id', optional: true

  validates :notify_user_id,   presence: true
  validates :notified_user_id, presence: true
  validates :action,           inclusion: { in: ['like', 'reply', 'request', 'accept', 'refract'] }
  validates :is_checked,       inclusion: { in: [true, false] }

  def self.format_to_rfc3339(formatted_time)
    formatted_time.to_datetime.new_offset('+0000').rfc3339
  end

  def format_notification
    formatted_notification = {}
    case action
    when 'like', 'reply'
      liked_or_replied_post                         = Post.find(post_id)
      formatted_notification[:action]               = action
      formatted_notification[:user_id]              = nil
      formatted_notification[:user_name]            = nil
      formatted_notification[:user_icon_url]        = nil
      formatted_notification[:checked]              = is_checked
      formatted_notification[:notified_at]          = Notification.format_to_rfc3339(created_at)
      formatted_notification[:post]                 = { 'id': liked_or_replied_post.id, 'content': liked_or_replied_post.content }

    when 'request', 'accept'
      requested_or_accepted_user                    = User.find(notify_user_id)
      formatted_notification[:action]               = action
      formatted_notification[:user_id]              = requested_or_accepted_user.userid
      formatted_notification[:user_name]            = requested_or_accepted_user.username
      formatted_notification[:user_icon_url]        = requested_or_accepted_user.image.url
      formatted_notification[:checked]              = is_checked
      formatted_notification[:notified_at]          = Notification.format_to_rfc3339(created_at)
      formatted_notification[:post]                 = { 'id': nil, 'content': nil }

    when 'refract'
      refracted_user                                = User.find(notify_user_id)
      refracted_post                                = Post.find(post_id)
      formatted_notification[:action]               = action
      formatted_notification[:user_id]              = refracted_user.userid
      formatted_notification[:user_name]            = refracted_user.username
      formatted_notification[:user_icon_url]        = refracted_user.image.url
      formatted_notification[:checked]              = is_checked
      formatted_notification[:notified_at]          = Notification.format_to_rfc3339(created_at)
      formatted_notification[:post]                 = { 'id': refracted_post.id, 'content': refracted_post.content }
    end
    formatted_notification
  end
end
