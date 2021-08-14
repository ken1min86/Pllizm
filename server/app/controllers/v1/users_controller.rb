module V1
  class UsersController < ApplicationController
    before_action :authenticate_v1_user!

    def disable_lock_description
      current_v1_user.update(need_description_about_lock: false)
      render json: current_v1_user, status: :ok
    end

    def index_of_users_follow_requested_by_me
      follow_requested_users = current_v1_user.follow_requesting_users
      # follow_requested_usersのうち、特定のカラムだけを抽出して配列に代入する
      extracted_follow_requested_users = []
      follow_requested_users.each do |follow_requested_user|
        hashed_follow_requested_user = follow_requested_user.attributes
        hashed_follow_requested_user['image'] = follow_requested_user.image.url
        extracted_follow_requested_user = hashed_follow_requested_user.slice(
          'id',
          'userid',
          'username',
          'image',
          'bio',
          'need_description_about_lock'
        )
        extracted_follow_requested_users.push(extracted_follow_requested_user)
      end
      render json: extracted_follow_requested_users, status: :ok
    end
  end
end
