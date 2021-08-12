module V1
  class FollowersController < ApplicationController
    before_action :authenticate_v1_user!

    def create
      follow_request = FollowRequest.find_by(requested_by: params[:follow_to], request_to: current_v1_user.id)
      follow_user = User.find(params[:follow_to])
      if follow_request
        follow_request.destroy
        followers = current_v1_user.mutual_follow(follow_user)
        render json: followers, status: :ok
      else
        render json: { errors: { title: 'フォローリクエストされていません', detail: 'フォローリクエストされていないユーザに対してフォロー承認できません' } }, status: :bad_request
      end
    end
  end
end
