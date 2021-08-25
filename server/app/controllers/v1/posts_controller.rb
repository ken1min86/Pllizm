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
      replied_post = Post.find_by(id: params[:post_id])
      reply_post = Post.new(post_params)
      if replied_post.blank?
        render_json_bad_request_with_custom_errors('投稿が存在しません', '存在しない投稿に対してリプライはできません')
      elsif replied_post.your_post?(current_v1_user) || replied_post.mutual_followers_post?(current_v1_user)
        if reply_post.save
          descendant_is_prams_id_tree_paths = TreePath.where(descendant: params[:post_id]).order(created_at: :asc)
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
      post = Post.find(params[:post_id])
      if post&.user_id == current_v1_user.id
        post.update(is_locked: !post.is_locked)
        render json: post, status: :ok
      else
        render json: post.errors, status: :bad_request
      end
    end

    def index_liked_posts
      likes = current_v1_user.likes.order(created_at: 'DESC')
      liked_posts = []
      likes.each do |like|
        liked_posts.push(like.liked_post)
      end
      # カレントユーザの投稿と、フォロワーの投稿それぞれに対して、仕様書通りにフォーマット
      return_posts = []
      liked_posts.each do |liked_post|
        if liked_post.user.id == current_v1_user.id
          formatted_current_user_post = liked_post.format_current_user_post(current_v1_user)
          return_posts.push(formatted_current_user_post)
        else
          formatted_follower_post = liked_post.format_follower_post(current_v1_user)
          return_posts.push(formatted_follower_post)
        end
      end
      render json: return_posts, status: :ok
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

    def index_current_user_posts
      current_user_posts = current_v1_user.posts.order(created_at: :desc)
      return_posts = []
      current_user_posts.each do |current_user_post|
        formatted_current_user_post = current_user_post.format_current_user_post(current_v1_user)
        return_posts.push(formatted_current_user_post)
      end
      render json: return_posts, status: :ok
    end

    def index_threads
      thread = {}
      status_of_current_post = Post.check_status_of_current_post(current_v1_user, params[:post_id])
      if status_of_current_post == Settings.constants.status_of_post[:current_user_post] \
        || status_of_current_post == Settings.constants.status_of_post[:mutual_follower_post]
        parent = Post.get_parent_of_current_post(current_v1_user, params[:post_id])
        thread.merge!(parent: parent)

        current = Post.get_current_according_to_status_of_current_post(current_v1_user, params[:post_id], status_of_current_post)
        thread.merge!(current: current)

        children = Post.get_children_of_current_post(current_v1_user, params[:post_id])
        thread.merge!(children: children)

      elsif status_of_current_post == Settings.constants.status_of_post[:not_mutual_follower_post] \
        || status_of_current_post == Settings.constants.status_of_post[:deleted] \
        || status_of_current_post == Settings.constants.status_of_post[:not_exist]
        current = Post.get_current_according_to_status_of_current_post(current_v1_user, params[:post_id], status_of_current_post)
        thread.merge!(current: current)
      end
      render json: thread, status: :ok
    end

    def index_replies
      replies = []
      current_user_posts_with_deleted = Post.with_deleted.where(user_id: current_v1_user.id).order(created_at: "DESC")
      current_user_posts_with_deleted.each do |current_user_post_with_deleted|
        replies.concat(Post.get_reply(current_v1_user, current_user_post_with_deleted))
      end
      render json: replies, status: :ok
    end

    private

    def post_params
      params.permit(:content, :image, :is_locked).merge(user_id: current_v1_user.id)
    end
  end
end
