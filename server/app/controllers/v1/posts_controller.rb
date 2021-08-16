module V1
  class PostsController < ApplicationController
    # ※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※
    # Postに紐づくuser_idに関して、
    # ログインユーザ以外のidは絶対に返さないこと。
    # ※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※

    before_action :authenticate_v1_user!

    def create
      post = Post.new(post_params)
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

    def create_reply
      replied_post = Post.find_by(id: params[:id])
      reply_post = Post.new(post_params)
      if replied_post.blank?
        render_json_bad_request_with_custom_errors('投稿が存在しません', '存在しない投稿に対してリプライはできません')
      elsif replied_post.your_post?(current_v1_user) || replied_post.mutual_followers_post?(current_v1_user)
        if reply_post.save
          # TreePathの作成
          descendant_is_prams_id_tree_paths = TreePath.where(descendant: params[:id]).order(created_at: :asc)
          depth = 1
          descendant_is_prams_id_tree_paths.each do |descendant_is_prams_id_tree_path|
            TreePath.create(
              ancestor: descendant_is_prams_id_tree_path.ancestor,
              descendant: reply_post.id,
              depth: depth
            )
            depth += 1
          end
          render json: {}, status: :ok
        else
          render json: reply_post.errors, status: :bad_request
        end
      else
        render_json_bad_request_with_custom_errors('リプライ対象外の投稿です', '自分または相互フォロワー以外の投稿にはリプライできません')
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

    def post_params
      params.permit(:content, :image, :is_locked).merge(user_id: current_v1_user.id)
    end
  end
end
