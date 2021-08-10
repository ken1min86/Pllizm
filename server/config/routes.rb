Rails.application.routes.draw do
  namespace 'v1' do
    mount_devise_token_auth_for 'User', at: 'auth', controllers: {
      registrations: 'v1/auth/registrations',
    }
    resources :posts, only: [:create, :destroy]
    put '/posts/:id/change_lock', to: 'posts#change_lock', as: :post_changeLock
  end
end
