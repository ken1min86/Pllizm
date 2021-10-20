module V1
  class LikesController < ApplicationController
    before_action :authenticate_v1_user!
    before_action :restrict_depending_on_whether_user_have_right

    def create
      liked_post = Post.find_by(id: params[:id])
      if liked_post.blank?
        render_json_bad_request_with_custom_errors(
          '存在しない投稿です',
          '存在しない投稿に対していいねできません'
        )
      elsif liked_post.your_post?(current_v1_user) || liked_post.followers_post?(current_v1_user)
        current_v1_user.likes.create(post_id: liked_post.id)
        liked_post.create_notification_like!(current_v1_user)
        render json: {}, status: :ok
      else
        render_json_bad_request_with_custom_errors(
          'いいね対象外の投稿です',
          '自分またはフォロワーの投稿以外にいいねできません'
        )
      end
    end

    def destroy
      like = Like.find_by(user_id: current_v1_user.id, post_id: params[:id])
      if like.blank?
        render_json_bad_request_with_custom_errors(
          'いいねをキャンセルできません',
          'いいねしていない投稿に対していいねのキャンセルはできません'
        )
      else
        like.destroy
        render json: {}, status: :ok
      end
    end
  end
end
