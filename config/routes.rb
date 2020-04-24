Rails.application.routes.draw do
  resources :labs, only: [:index, :create, :show, :update, :destroy]
  resources :users, only: [:index, :create, :show, :update, :destroy]
  resources :events, only: [:index, :create, :show, :update, :destroy]
  resources :goals, only: [:index, :create, :show, :update, :destroy]
  resources :reports, only: [:index, :create, :show, :update, :destroy]

  post 'login', to: 'sessions#login', as: 'login'
end
