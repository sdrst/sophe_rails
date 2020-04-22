Rails.application.routes.draw do
  resources :labs, only: [:index, :create, :show, :update, :destroy]
  resources :users, only: [:index, :create, :show, :update, :destroy]

  post 'login', to: 'sessions#login', as: 'login'
end
