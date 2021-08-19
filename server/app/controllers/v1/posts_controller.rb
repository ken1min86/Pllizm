module V1
  class PostsController < ApplicationController
    # ※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※
    # Postに紐づくuser_idに関して、
    # ログインユーザ以外のidは絶対に返さないこと。
    # ※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※

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

    def index_liked_posts
      liked_posts = current_v1_user.liked_posts.order(created_at: 'DESC')
      extracted_liked_posts = Post.extract_disclosable_culumns_from_posts_array(liked_posts)
      render json: extracted_liked_posts, status: :ok
    end

    def index_current_user_and_mutual_follower_posts
      followers = current_v1_user.followings

      # カレントユーザとフォロワーのすべての投稿を取得
      current_user_posts = current_v1_user.posts
      followers_posts = []
      followers.each do |follower|
        follower_posts = follower.posts
        followers_posts.push(follower_posts)
      end
      current_user_and_followers_posts = followers_posts.push(current_user_posts)
      # 配列の平坦化
      current_user_and_followers_posts.flatten!
      # 取得したすべての投稿のうち、ルートのみを抽出(=リプライの除去)
      current_user_and_followers_root_posts = Post.extract_root_posts(current_user_and_followers_posts)
      # 作成日の降順でソート
      current_user_and_followers_root_posts.sort_by! { |post| post["created_at"] }.reverse!
      # カレントユーザの投稿と、フォロワーの投稿それぞれに対して、仕様書通りにフォーマット
      return_posts = []
      current_user_and_followers_root_posts.each do |current_user_and_followers_root_post|
        if current_user_and_followers_root_post.user_id == current_v1_user.id
          formatted_current_user_post = current_user_and_followers_root_post.format_current_user_post(current_v1_user)
          return_posts.push(formatted_current_user_post)
        else
          formatted_follower_post = current_user_and_followers_root_post.format_follower_post(current_v1_user)
          return_posts.push(formatted_follower_post)
        end
      end
      render json: return_posts, status: :ok
    end

    private

    def post_params
      params.permit(:content, :image, :is_locked).merge(user_id: current_v1_user.id)
    end
  end
end
