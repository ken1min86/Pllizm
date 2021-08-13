module V1
  class FollowRequestsController < ApplicationController
    before_action :authenticate_v1_user!

    def create
      be_requested_to_follow_user = User.find_by(id: params[:request_to])
      follow_request = FollowRequest.new(requested_by: current_v1_user.id, request_to: params[:request_to])
      if be_requested_to_follow_user.nil?
        render_json_bad_request_with_custom_errors('リクエスト対象のユーザが見つかりません', 'request_toのIDと一致するユーザが見つかりません')
      elsif current_v1_user.request_following?(be_requested_to_follow_user)
        render json: { errors: { title: 'すでにフォローリクエスト済みです', detail: 'すでにフォローリクエストをしています' } }, status: :bad_request
      elsif be_requested_to_follow_user.request_following?(current_v1_user)
        render_json_bad_request_with_custom_errors('フォローリクエストされています', 'request_toで指定したユーザからすでにフォローリクエストされています')
      elsif current_v1_user.following?(be_requested_to_follow_user)
        render_json_bad_request_with_custom_errors('すでにフォロー中です', 'フォロー中のユーザにフォローリクエストは送れません')
      elsif current_v1_user == be_requested_to_follow_user
        render_json_bad_request_with_custom_errors('自身に対するフォローリクエストです', '自身に対するフォローリクエストはできません')
      elsif follow_request.save
        render json: follow_request, status: :ok
      else
        render json: follow_request.errors, status: :bad_request
      end
    end

    def destroy
      follow_request = FollowRequest.find_by(requested_by: params[:requested_by], request_to: current_v1_user.id)
      if follow_request
        follow_request.destroy
        render json: follow_request, status: :ok
      else
        render_json_bad_request_with_custom_errors('フォローリクエストされていません', 'フォローリクエストされていないユーザに対してフォロー拒否できません')
      end
    end

    private

    def render_json_bad_request_with_custom_errors(title, detail)
      render json: { errors: { title: title, detail: detail } }, status: :bad_request
    end
  end
end
