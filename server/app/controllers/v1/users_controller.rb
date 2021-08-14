module V1
  class UsersController < ApplicationController
    before_action :authenticate_v1_user!

    def disable_lock_description
      current_v1_user.update(need_description_about_lock: false)
      render json: current_v1_user, status: :ok
    end

    def index_of_mutual_follow_users
      mutual_follow_users = current_v1_user.followings
      # mutual_follow_usersのうち、仕様書に指定されたカラムだけを抽出して配列に代入する
      extracted_mutual_follow_users = extract_disclosable_culumns_from_users_array(mutual_follow_users)
      render json: extracted_mutual_follow_users, status: :ok
    end

    def index_of_users_follow_requested_by_me
      follow_requested_users = current_v1_user.follow_requesting_users
      # follow_requested_usersのうち、仕様書に指定されたカラムだけを抽出して配列に代入する
      extracted_follow_requested_users = extract_disclosable_culumns_from_users_array(follow_requested_users)
      render json: extracted_follow_requested_users, status: :ok
    end

    def index_of_users_follow_request_to_me
      follow_request_to_me_users = current_v1_user.follow_requesting_to_me_users
      # follow_request_to_me_usersのうち、仕様書に指定されたカラムだけを抽出して配列に代入する
      extracted_follow_request_to_me_users = extract_disclosable_culumns_from_users_array(follow_request_to_me_users)
      render json: extracted_follow_request_to_me_users, status: :ok
    end

    private

    def extract_disclosable_culumns_from_users_array(users_array)
      extracted_users = []
      users_array.each do |user|
        hashed_user = user.attributes
        hashed_user['image'] = user.image.url
        extracted_user = hashed_user.slice(
          'id',
          'userid',
          'username',
          'image',
          'bio',
          'need_description_about_lock'
        )
        extracted_users.push(extracted_user)
      end
      extracted_users
    end
  end
end
