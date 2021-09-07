Rails.application.routes.draw do
  namespace 'v1' do
    mount_devise_token_auth_for 'User', at: 'auth', controllers: {
      registrations: 'v1/auth/registrations',
    }
    put '/disable_lock_description', to: 'users#disable_lock_description', as: :disableLockDescription

    post   '/follow_requests/create',   to: 'follow_requests#create',                        as: :follow_requests
    post   '/follow_requests/accept',   to: 'followers#create',                              as: :followers
    delete '/follow_requests/refuse',   to: 'follow_requests#destroy_follow_requests_to_me', as: :follow_requests_to_me
    delete '/follow_requests/outgoing', to: 'follow_requests#destroy_follow_requests_by_me', as: :follow_requests_by_me
    get    '/follow_requests/incoming', to: 'users#index_of_users_follow_request_to_me',     as: :follow_request_to_me_users
    get    '/follow_requests/outgoing', to: 'users#index_of_users_follow_requested_by_me',   as: :follow_requested_by_me_users

    get    '/followers',              to: 'users#index_of_followers', as: :follow_users
    delete '/followers/:follower_id', to: 'followers#destroy',        as: :follower

    resources :posts, only: [:create, :destroy]
    get  '/posts/me_and_followers', to: 'posts#index_me_and_followers_posts', as: :me_and_followers_posts
    get  '/posts/me',               to: 'posts#index_current_user_posts',     as: :current_user_posts
    get  '/likes',                  to: 'posts#index_liked_posts',            as: :liked_posts
    get  '/replies',                to: 'posts#index_replies',                as: :replies
    post '/posts/:id/likes',        to: 'likes#create',                       as: :post_likes
    get  '/posts/:id/threads',      to: 'posts#index_threads',                as: :post_threads
    post '/posts/:id/replies',      to: 'posts#create_replies',               as: :post_replies
    put  '/posts/:id/change_lock',  to: 'posts#change_lock',                  as: :post_changeLock

    get  '/refract_candidates',             to: 'posts#index_refract_candidates',              as: :post_refract_candidates
    get  '/refract_candidates/:id/threads', to: 'posts#thread_above_candidate',                as: :thread_above_candidate
    post '/refracts/perform',               to: 'refracts#perform_refract',                    as: :refract_performed
    post '/refracts/skip',                  to: 'refracts#skip',                               as: :skip
    get  '/posts/refracts/by_me',           to: 'posts#index_posts_refracted_by_current_user', as: :post_refracted_by_current_user
  end
end
