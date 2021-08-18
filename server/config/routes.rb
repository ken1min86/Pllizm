Rails.application.routes.draw do
  namespace 'v1' do
    mount_devise_token_auth_for 'User', at: 'auth', controllers: {
      registrations: 'v1/auth/registrations',
    }
    put '/user/disable_lock_description', to: 'users#disable_lock_description', as: :user_disableLockDescription
    get '/mutual_follow_users', to: 'users#index_of_mutual_follow_users', as: :mutual_follow_users
    get '/follow_requested_by_me_users', to: 'users#index_of_users_follow_requested_by_me', as: :follow_requested_by_me_users
    get '/follow_request_to_me_users', to: 'users#index_of_users_follow_request_to_me', as: :follow_request_to_me_users
    resources :posts, only: [:create, :destroy]
    resources :posts do
      resources :likes, only: [:create]
    end
    post '/posts/:id/reply', to: 'posts#create_reply', as: :post_reply
    put '/posts/:id/change_lock', to: 'posts#change_lock', as: :post_changeLock
    post '/follow_requests', to: 'follow_requests#create', as: :follow_requests
    delete '/follow_requests_to_me', to: 'follow_requests#destroy_follow_requests_to_me', as: :follow_requests_to_me
    delete '/follow_requests_by_me', to: 'follow_requests#destroy_follow_requests_by_me', as: :follow_requests_by_me
    resources :followers, only: [:create]
    delete '/followers', to: 'followers#destroy', as: :follower
  end
end
