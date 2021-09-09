module V1
  class FollowRequestsController < ApplicationController
    before_action :authenticate_v1_user!

    def create
      user_requested_following_by_me = User.find_by(userid: params[:request_to])
      if user_requested_following_by_me.blank?
        render_json_bad_request_with_custom_errors(
          'リクエスト対象のユーザが見つかりません',
          'request_toのIDと一致するユーザが見つかりません'
        )
        return
      end
      if current_v1_user.request_following?(user_requested_following_by_me)
        render_json_bad_request_with_custom_errors(
          'すでにフォローリクエスト済みです',
          'すでにフォローリクエストをしています'
        )
        return
      end
      if user_requested_following_by_me.request_following?(current_v1_user)
        render_json_bad_request_with_custom_errors(
          'フォローリクエストされています',
          'request_toで指定したユーザからすでにフォローリクエストされています'
        )
        return
      end
      if current_v1_user.following?(user_requested_following_by_me)
        render_json_bad_request_with_custom_errors(
          'すでにフォロー中です',
          'フォロー中のユーザにフォローリクエストは送れません'
        )
        return
      end
      if current_v1_user == user_requested_following_by_me
        render_json_bad_request_with_custom_errors(
          '自身に対するフォローリクエストです',
          '自身に対するフォローリクエストはできません'
        )
        return
      end
      FollowRequest.create(requested_by: current_v1_user.id, request_to: user_requested_following_by_me.id)
      render json: {}, status: :ok
    end

    def destroy_follow_requests_to_me
      follow_requested_user = User.find_by(userid: params[:requested_by])
      if follow_requested_user.blank?
        render_json_bad_request_with_custom_errors('存在しないuseridです', 'フォローリクエストされているユーザのuseridを設定してください')
      else
        follow_request = FollowRequest.find_by(requested_by: follow_requested_user.id, request_to: current_v1_user.id)
        if follow_request
          follow_request.destroy
          render json: {}, status: :ok
        else
          render_json_bad_request_with_custom_errors('フォローリクエストされていません', 'フォローリクエストされていないユーザに対してフォロー拒否できません')
        end
      end
    end

    def destroy_follow_requests_by_me
      follow_requested_user = User.find_by(userid: params[:request_to])
      if follow_requested_user.blank?
        render_json_bad_request_with_custom_errors('存在しないuseridです', 'フォローリクエストされているユーザのuseridを設定してください')
      else
        follow_request = FollowRequest.find_by(requested_by: current_v1_user.id, request_to: follow_requested_user.id)
        if follow_request
          follow_request.destroy
          render json: follow_request, status: :ok
        else
          render_json_bad_request_with_custom_errors('フォローリクエストしていません', 'フォローリクエストしていないユーザに対してフォローリクエスト取り下げはできません')
        end
      end
    end
  end
end
