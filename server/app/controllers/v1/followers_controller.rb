module V1
  class FollowersController < ApplicationController
    before_action :authenticate_v1_user!

    def create
      follow_request = FollowRequest.find_by(requested_by: params[:follow_to], request_to: current_v1_user.id)
      follow_user = User.find(params[:follow_to])
      if follow_request.blank?
        render_json_bad_request_with_custom_errors('フォローリクエストされていません', 'フォローリクエストされていないユーザに対してフォロー承認できません')
      else
        follow_request.destroy
        followers = current_v1_user.mutual_follow(follow_user)
        render json: followers, status: :ok
      end
    end

    def destroy
      follow_relationship = Follower.find_by(followed_by: current_v1_user.id, follow_to: params[:follower_id])
      reverse_of_follow_relationship = Follower.find_by(followed_by: params[:follower_id], follow_to: current_v1_user.id)
      if follow_relationship.blank? || reverse_of_follow_relationship.blank?
        render_json_bad_request_with_custom_errors('フォローしていません', 'フォローしていないユーザに対してフォロー解除はできません')
      else
        follow_relationship.destroy
        reverse_of_follow_relationship.destroy
        render json: [follow_relationship, reverse_of_follow_relationship], status: :ok
      end
    end
  end
end
