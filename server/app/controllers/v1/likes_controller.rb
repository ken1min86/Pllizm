module V1
  class LikesController < ApplicationController
    before_action :authenticate_v1_user!

    def create
      liked_post = Post.find_by(id: params[:post_id])
      if liked_post.blank?
        render_json_bad_request_with_custom_errors('存在しない投稿です', '存在しない投稿に対していいねできません')
      elsif liked_post.your_post?(current_v1_user) || liked_post.mutual_followers_post?(current_v1_user)
        like = current_v1_user.likes.create(post_id: liked_post.id)
        render json: like, status: :ok
      else
        render_json_bad_request_with_custom_errors('いいね対象外の投稿です', '自分またはフォロワーの投稿以外にいいねできません')
      end
    end

    def index_liked_posts
      liked_posts = current_v1_user.liked_posts.order(created_at: 'DESC')
      extracted_liked_posts = extract_disclosable_culumns_from_posts_array(liked_posts)
      render json: extracted_liked_posts, status: :ok
    end

    private

    def extract_disclosable_culumns_from_posts_array(posts_array)
      extracted_posts = []
      posts_array.each do |post|
        hashed_post = post.attributes
        hashed_post['image'] = post.image.url
        extracted_post = hashed_post.slice(
          'id',
          'content',
          'image',
          'icon_id',
          'is_locked',
          'deleted_at',
          'created_at',
          'updated_at'
        )
        extracted_posts.push(extracted_post)
      end
      extracted_posts
    end
  end
end
