module V1
  class FollowersController < ApplicationController
    before_action :authenticate_v1_user!

    def create
      follow_user = User.find_by(userid: params[:follow_to])
      if follow_user.blank?
        render_json_bad_request_with_custom_errors('存在しないuseridです', 'フォローリクエストされているユーザのuseridを設定してください')
      else
        follow_request = FollowRequest.find_by(requested_by: follow_user.id, request_to: current_v1_user.id)
        if follow_request.blank?
          render_json_bad_request_with_custom_errors('フォローリクエストされていません', 'フォローリクエストされていないユーザに対してフォロー承認できません')
        else
          follow_request.destroy
          follower = current_v1_user.follow(follow_user)
          follow_user.create_notification_follow_accept!(current_v1_user)
          render json: follower, status: :ok
        end
      end
    end

    def destroy
      follower = User.find_by(userid: params[:follower_id])
      if follower.blank?
        render_json_bad_request_with_custom_errors('存在しないuseridです', 'フォローリクエストされているユーザのuseridを設定してください')
      else
        follow_relationship = Follower.find_by(followed_by: current_v1_user.id, follow_to: follower.id)
        reverse_of_follow_relationship = Follower.find_by(followed_by: follower.id, follow_to: current_v1_user.id)
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
end
