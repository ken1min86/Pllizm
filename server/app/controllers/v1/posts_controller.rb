module V1
  class PostsController < ApplicationController
    # ※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※
    # Postに紐づくuser_idに関して、
    # ログインユーザ以外のidは絶対に返さないこと。
    # ※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※

    # 順番を入れ替えないこと(authenticate→verify_refractable)
    before_action :authenticate_v1_user!
    before_action :verify_refractable_after_authenticate, only: [:index_refract_candidates, :thread_above_candidate]

    def create
      post = Post.new(post_params)
      if post.save
        render json: post, status: :ok
      else
        render json: post.errors, status: :bad_request
      end
    end

    def destroy
      post = Post.find_by(id: params[:id])
      if post.present? && post.user_id == current_v1_user.id
        post.destroy
        render json: post, status: :ok
      else
        render_json_bad_request_with_custom_errors(
          '投稿idが不正です',
          '自分の投稿に紐づくidを設定してください'
        )
      end
    end

    def create_replies
      replied_post = Post.find_by(id: params[:id])
      reply_post = Post.new(post_params)
      if replied_post.blank?
        render_json_bad_request_with_custom_errors(
          '投稿が存在しません',
          '存在しない投稿に対してリプライはできません'
        )
        return
      end
      if replied_post.your_post?(current_v1_user) || replied_post.followers_post?(current_v1_user)
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
          render json: reply_post, status: :ok
        else
          render json: reply_post.errors, status: :bad_request
        end
      else
        render_json_bad_request_with_custom_errors(
          'リプライ対象外の投稿です',
          '自分または相互フォロワー以外の投稿にはリプライできません'
        )
      end
    end

    def change_lock
      post = Post.find_by(id: params[:id])
      if post&.your_post?(current_v1_user)
        post.update(is_locked: !post.is_locked)
        render json: post, status: :ok
      else
        render_json_bad_request_with_custom_errors(
          '対象外の投稿です',
          '削除済みでない自分の投稿のidを指定してください'
        )
      end
    end

    def index_liked_posts
      likes       = current_v1_user.likes.order(created_at: 'DESC')
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

    def index_me_and_followers_posts
      followers = current_v1_user.followings

      current_user_posts = current_v1_user.posts
      followers_posts    = []
      followers.each do |follower|
        follower_posts = follower.posts
        followers_posts.push(follower_posts)
      end
      current_user_and_followers_posts = followers_posts.push(current_user_posts)
      current_user_and_followers_posts.flatten!

      current_user_and_followers_root_posts = Post.extract_root_posts(current_user_and_followers_posts)
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
      return_posts       = []
      current_user_posts.each do |current_user_post|
        formatted_current_user_post = current_user_post.format_current_user_post(current_v1_user)
        return_posts.push(formatted_current_user_post)
      end
      render json: return_posts, status: :ok
    end

    def index_threads
      thread = {}
      status_of_current_post = Post.check_status_of_post(current_v1_user, params[:id])
      if status_of_current_post == Settings.constants.status_of_post[:current_user_post] \
        || status_of_current_post == Settings.constants.status_of_post[:follower_post]
        parent = Post.get_parent_of_current_post(current_v1_user, params[:id])
        thread.merge!(parent: parent)

        current = Post.get_current_according_to_status_of_current_post(current_v1_user, params[:id], status_of_current_post)
        thread.merge!(current: current)

        children = Post.get_children_of_current_post(current_v1_user, params[:id])
        thread.merge!(children: children)

      elsif status_of_current_post == Settings.constants.status_of_post[:not_follower_post] \
        || status_of_current_post == Settings.constants.status_of_post[:deleted] \
        || status_of_current_post == Settings.constants.status_of_post[:not_exist]
        current = Post.get_current_according_to_status_of_current_post(current_v1_user, params[:id], status_of_current_post)
        thread.merge!(current: current)
      end
      render json: thread, status: :ok
    end

    def index_replies
      replies = []
      current_user_posts_with_deleted = Post.with_deleted.where(user_id: current_v1_user.id).order(created_at: "DESC")
      current_user_posts_with_deleted.each do |current_user_post_with_deleted|
        reply = Post.get_reply(current_v1_user, current_user_post_with_deleted)
        if reply.present?
          formatted_reply = reply.format_current_user_post(current_v1_user)
          replies.push(formatted_reply)
        end
      end
      render json: replies, status: :ok
    end

    def index_refract_candidates
      # いいねした投稿とリプライから、リフラクトの候補を取得
      refract_candidates_of_like, refract_candidates_of_reply = Post.get_not_formatted_refract_candidates(current_v1_user)
      # マージ・ソートして、いいねの投稿とリプライの投稿をそれぞれ仕様書通りにフォーマット
      hashed_refract_candidates = refract_candidates_of_like.concat(refract_candidates_of_reply)
      hashed_refract_candidates.sort_by! { |post| post[:datetime_for_sort] }.reverse!
      formatted_refract_candidates = []
      hashed_refract_candidates.each do |hashed_refract_candidate|
        refract_candidate = Post.find(hashed_refract_candidate[:id])
        if hashed_refract_candidate[:created_at] == hashed_refract_candidate[:datetime_for_sort]
          formatted_refract_candidates.push({ reply: refract_candidate.format_post(current_v1_user) })
        else
          formatted_refract_candidates.push({ like: refract_candidate.format_post(current_v1_user) })
        end
      end

      render json: formatted_refract_candidates, status: :ok
    end

    def thread_above_candidate
      candidate_post = Post.find_by(id: params[:id])
      if candidate_post.blank?
        render_json_bad_request_with_custom_errors(
          'パラメータのidが不正です',
          '削除済みでない存在する投稿のidを設定してください。'
        )
      else
        posts_above_candidate_post = candidate_post.ancestor_posts.with_deleted.order(created_at: :asc)
        thread_above_candidate = []
        posts_above_candidate_post.each do |post_above_candidate|
          status         = Post.check_status_of_post(current_v1_user, post_above_candidate.id)
          formatted_post = Post.get_current_according_to_status_of_current_post(current_v1_user, post_above_candidate.id, status)
          thread_above_candidate.push(formatted_post)
        end
        render json: thread_above_candidate, status: :ok
      end
    end

    def index_posts_refracted_by_current_user
      formatted_refracted_posts = []
      performed_current_user_refracts = current_v1_user.get_performed_current_user_refracts
      performed_current_user_refracts.each do |performed_current_user_refract|
        case performed_current_user_refract.category
        when 'like'
          liked_post           = Post.with_deleted.find(performed_current_user_refract.post_id)
          formatted_liked_post = Post.format_refracted_by_me_post_of_like(
            current_v1_user,
            liked_post,
            performed_current_user_refract.updated_at
          )
          formatted_refracted_posts.push(formatted_liked_post)
        when 'reply'
          replied_leaf_post       = Post.with_deleted.find(performed_current_user_refract.post_id)
          formatted_replied_posts = Post.format_refracted_by_me_posts_of_reply(
            current_v1_user,
            replied_leaf_post,
            performed_current_user_refract.updated_at
          )
          formatted_refracted_posts.push(formatted_replied_posts)
        end
      end
      render json: formatted_refracted_posts, status: :ok
    end

    # 【2021/09/07 メモ】
    # FollowerRefractに紐付くfollowerは必ずフォロワーとして存在する前提で実装してよい。
    # フォロー解除された場合や、アカウント削除した場合にはFollowerRefractも削除するように今後修正するため。
    def index_posts_refracted_by_followers
      formatted_refracted_posts = []
      follower_refracts         = current_v1_user.get_follower_refracts
      follower_refracts.each do |follower_refract|
        follower = follower_refract.follower
        case follower_refract.category
        when 'like'
          refracted_post       = Post.with_deleted.find(follower_refract.post_id)
          formatted_liked_post = Post.format_refracted_by_follower_post_of_like(
            current_user: current_v1_user,
            refracted_by: follower,
            liked_post: refracted_post,
            refracted_at: follower_refract.created_at
          )
          formatted_refracted_posts.push(formatted_liked_post)
        when 'reply'
          refracted_post          = Post.with_deleted.find(follower_refract.post_id)
          formatted_replied_posts = Post.format_refracted_by_follower_posts_of_reply(
            current_user: current_v1_user,
            refracted_by: follower,
            replied_leaf_post: refracted_post,
            refracted_at: follower_refract.created_at
          )
          formatted_refracted_posts.push(formatted_replied_posts)
        end
      end
      render json: formatted_refracted_posts, status: :ok
    end

    private

    def post_params
      params.permit(:content, :image, :is_locked).merge(user_id: current_v1_user.id)
    end
  end
end
