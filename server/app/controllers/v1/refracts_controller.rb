module V1
  class RefractsController < ApplicationController
    # 順番を入れ替えないこと(authenticate→verify_refractable)
    before_action :authenticate_v1_user!
    before_action :verify_refractable_after_authenticate, only: [:perform_refract, :skip]

    # リフラクト候補取得メソッド(Post.get_unformatted_refract_candidates)では、
    # いいねした投稿とリプライの投稿が重複した場合はリプライの投稿のみが返されるため、
    # 本APIではいいねとリプライの投稿が重複するケースについて考慮する必要はない。
    def perform_refract
      params_post = Post.find_by(id: params[:refract_candidate_id])
      refract_candidates_of_like, refract_candidates_of_reply = Post.get_unformatted_refract_candidates(current_v1_user)

      if params_post.blank?
        render_json_forbitten_with_custom_errors(
          'リフラクト対象外の投稿です',
          'リフラクト候補の投稿を設定してください。'
        )

      elsif refract_candidates_of_like.select { |c| c[:id] == params_post.id }.present?
        current_user_refract = current_v1_user.get_current_user_refract
        current_user_refract.update_current_user_refract_when_refarced_liked_post(params_post)

        liked_follower = params_post.user
        FollowerRefract.create_follower_refract_when_refarced_liked_post(current_v1_user, liked_follower, params_post)

        render json: {}, status: :ok

      elsif refract_candidates_of_reply.select { |c| c[:id] == params_post.id }.present?
        current_user_refract = current_v1_user.get_current_user_refract
        current_user_refract.update_current_user_refract_when_refarced_replied_post(params_post)

        # params postに紐づくスレッドの投稿主のうち、フォロワーのみを抽出
        posts_of_thread = params_post.ancestor_posts
        followers = []
        posts_of_thread.each do |post_of_thread|
          posted_user = post_of_thread.user
          if current_v1_user.following?(posted_user)
            followers.push(posted_user)
          end
        end
        followers.uniq!

        followers.each do |follower|
          FollowerRefract.create_follower_refract_when_refarced_replied_post(current_v1_user, follower, params_post)
        end

        render json: {}, status: :ok
      end
    end

    def skip
      current_user_refract = current_v1_user.get_current_user_refract
      current_user_refract.update(performed_refract: true)
      render json: {}, status: :ok
    end
  end
end
