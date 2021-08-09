module V1
  class PostsController < ApplicationController
    before_action :authenticate_v1_user!

    def create
      post = Post.new(post_params)
      if post.save
        render json: post, status: :ok
      else
        render json: post.errors, status: :bad_request
      end
    end

    private

    def post_params
      params.permit(:content, :image, :is_locked).merge(user_id: current_v1_user.id)
    end
  end
end
