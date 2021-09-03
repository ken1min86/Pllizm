module V1
  class RefractsController < ApplicationController
    # 順番を入れ替えないこと(authenticate→verify_refractable)
    before_action :authenticate_v1_user!
    before_action :verify_refractable_after_authenticate, only: [:perform_refract]

    # リフラクト候補取得メソッド(Post.get_unformatted_refract_candidates)では、
    # いいねした投稿とリプライの投稿が重複した場合はリプライの投稿のみが返されるため、
    # 本APIではいいねとリプライの投稿が重複するケースについて考慮する必要はない。
    def perform_refract
      params_post = Post.find_by(id: params[:refract_candidate_id])
      refract_candidates_of_like, refract_candidates_of_reply = Post.get_unformatted_refract_candidates(current_v1_user)

      if params_post.blank?
        render_json_forbitten_with_custom_errors('リフラクト対象外の投稿です', 'リフラクト候補の投稿を設定してください。')

      elsif refract_candidates_of_like.select { |c| c[:id] == params_post.id }.present?
        current_user_refract = current_v1_user.current_user_refracts.find_by(performed_refract: false)
        current_user_refract.update(
          performed_refract: true,
          post_id: params_post.id,
          category: 'like',
        )

        follower = params_post.user
        FollowerRefract.create(
          user_id: follower.id,
          follower_id: current_v1_user.id,
          post_id: params_post.id,
          category: 'like',
        )

        render json: {}, status: :ok

      elsif refract_candidates_of_reply.select { |c| c[:id] == params_post.id }.present?
        current_user_refract = current_v1_user.current_user_refracts.find_by(performed_refract: false)
        current_user_refract.update(
          performed_refract: true,
          post_id: params_post.id,
          category: 'reply',
        )

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

        followers.each do |follower1|
          FollowerRefract.create(
            user_id: follower1.id,
            follower_id: current_v1_user.id,
            post_id: params_post.id,
            category: 'reply',
          )
        end

        render json: {}, status: :ok
      end
    end
  end
end
