module V1
  class FollowRequestsController < ApplicationController
    before_action :authenticate_v1_user!

    def create
      be_requested_to_follow_user = User.find_by(id: params[:request_to])
      follow_request = FollowRequest.new(requested_by: current_v1_user.id, request_to: params[:request_to])
      if be_requested_to_follow_user == nil
        render json: { errors: { title: 'レコードが見つかりません', detail: 'request_toのIDと一致するユーザが見つかりません' } }, status: :bad_request
      elsif current_v1_user.request_following?(be_requested_to_follow_user)
        render json: { errors: { title: 'すでにフォローリクエスト済みです', detail: 'すでにフォローリクエストをしています' } }, status: :bad_request
      elsif be_requested_to_follow_user.request_following?(current_v1_user)
        render json: { errors: { title: 'フォローリクエストされています', detail: 'request_toで指定したユーザからフォローリクエストされています' } }, status: :bad_request
      elsif follow_request.save
        render json: follow_request, status: :ok
      else
        render json: follow_request.errors, status: :bad_request
      end
    end
  end
end
