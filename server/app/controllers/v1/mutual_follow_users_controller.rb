module V1
  class MutualFollowUsersController < ApplicationController
    before_action :authenticate_v1_user!

    def index
      mutual_follow_users = current_v1_user.followings
      # mutual_follow_usersのうち、特定のカラムだけを抽出して配列に代入する
      extracted_mutual_follow_users = []
      mutual_follow_users.each do |mutual_follow_user|
        hashed_mutual_follow_user = mutual_follow_user.attributes
        hashed_mutual_follow_user['image'] = mutual_follow_user.image.url
        extracted_mutual_follow_user = hashed_mutual_follow_user.slice(
          'id',
          'userid',
          'username',
          'image',
          'bio',
          'need_description_about_lock'
        )
        extracted_mutual_follow_users.push(extracted_mutual_follow_user)
      end
      render json: extracted_mutual_follow_users, status: :ok
    end
  end
end
