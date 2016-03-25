Rails.application.routes.draw do
  root 'events#index'
  get 'auth/:provider/callback' => 'sessions#callback'
  resources :events
  resource :sessions, only: [:create, :destroy]
  resources :users, only: [:create, :edit, :update]
end
