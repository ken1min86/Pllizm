module V1
  class PostsController < ApplicationController
  # ※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※
  # Postに紐づくuser_idに関して、
  # ログインユーザ以外のidは絶対に返さないこと。
  # ※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※

    before_action :authenticate_v1_user!

    def create
      post = Post.new(post_params_when_create)
      if post.save
        render json: post, status: :ok
      else
        render json: post.errors, status: :bad_request
      end
    end

    def destroy
      post = Post.find(params[:id])
      if post&.user_id == current_v1_user.id
        post.destroy
        render json: post, status: :ok
      else
        render json: post.errors, status: :bad_request
      end
    end

    def change_lock
      post = Post.find(params[:id])
      if post&.user_id == current_v1_user.id
        post.update(is_locked: !post.is_locked)
        render json: post, status: :ok
      else
        render json: post.errors, status: :bad_request
      end
    end

    private

    def post_params_when_create
      params.permit(:content, :image, :is_locked).merge(user_id: current_v1_user.id)
    end
  end
end
