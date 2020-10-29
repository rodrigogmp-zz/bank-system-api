Rails.application.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth' 

      resources :users, only: [:create]
      
      post 'account' => 'accounts#create'
      get 'account' => 'accounts#show'
      patch 'account' => 'accounts#update'
      delete 'account' => 'accounts#destroy'
      get 'account/bank_statement' => 'accounts#bank_statement'
      post 'account/operations' => 'operations#create'
      get 'account/operations' => 'operations#index'
    end
  end
end
