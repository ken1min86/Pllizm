module V1
  class NotificationsController < ApplicationController
    before_action :authenticate_v1_user!

    def index
      notifications = current_v1_user.notifications_to_me.order(created_at: 'DESC')
      formatted_notifications = []
      notifications.each do |notification|
        formatted_notifications.push(notification.format_notification)
        notification.update(is_checked: true)
      end
      render json: { notifications: formatted_notifications }, status: :ok
    end
  end
end
