Rails.application.routes.draw do
  namespace 'v1' do
    mount_devise_token_auth_for 'User', at: 'auth', controllers: {
      registrations: 'v1/auth/registrations',
    }
    put '/user/disable_lock_description', to: 'users#disable_lock_description', as: :user_disableLockDescription

    get    '/follow_requested_by_me_users', to: 'users#index_of_users_follow_requested_by_me',   as: :follow_requested_by_me_users
    get    '/follow_request_to_me_users',   to: 'users#index_of_users_follow_request_to_me',     as: :follow_request_to_me_users
    post   '/follow_requests',              to: 'follow_requests#create',                        as: :follow_requests
    delete '/follow_requests_to_me',        to: 'follow_requests#destroy_follow_requests_to_me', as: :follow_requests_to_me
    delete '/follow_requests_by_me',        to: 'follow_requests#destroy_follow_requests_by_me', as: :follow_requests_by_me

    resources :followers, only: [:create]
    get    '/mutual_follow_users',    to: 'users#index_of_mutual_follow_users', as: :mutual_follow_users
    delete '/followers/:follower_id', to: 'followers#destroy',                  as: :follower

    resources :posts, only: [:create, :destroy]
    get '/posts/liked',                                        to: 'posts#index_liked_posts',        as: :liked_posts
    get '/posts/replies',                                      to: 'posts#index_replies',            as: :post_replies
    get '/posts/refract_candidates',                           to: 'posts#index_refract_candidates', as: :post_refract_candidates
    get '/posts/:refract_candidate_id/thread_above_candidate', to: 'posts#thread_above_candidate',   as: :thread_above_candidate
    get '/posts/refracts/by_current_user',                     to: 'posts#index_posts_refracted_by_current_user',
                                                               as: :post_refracted_by_current_user
    get '/posts/current_user',                                 to: 'posts#index_current_user_posts', as: :current_user_posts
    get '/posts/current_user_and_mutual_follower',             to: 'posts#index_current_user_and_mutual_follower_posts',
                                                               as: :current_user_and_mutual_follower_posts
    resources :posts do
      resources :likes, only: [:create]
    end
    get  '/posts/:post_id/threads',     to: 'posts#index_threads', as: :post_threads
    post '/posts/:post_id/reply',       to: 'posts#create_reply',  as: :post_reply
    put  '/posts/:post_id/change_lock', to: 'posts#change_lock',   as: :post_changeLock

    post '/posts/:refract_candidate_id/refracts', to: 'refracts#perform_refract', as: :refract_performed

    post '/refracts/skip', to: 'refracts#skip', as: :skip
  end
end
