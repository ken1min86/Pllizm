module V1
  class PostsController < ApplicationController
    before_action :authenticate_v1_user!

    # まだ仮実装
    # まだ仮実装
    # まだ仮実装
    def create
      post = Post.new(post_params)
      post.save
    end

    private
    def post_params
      params.permit(:content, :image, :is_locked)
    end
  end
end
