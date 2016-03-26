Rails.application.routes.draw do
  root 'events#index'
  get 'auth/:provider/callback' => 'sessions#callback'
  resources :events, except: [:destroy] do
    collection do
      post :search
      get :mine
    end
  end
  resources :orders, only: [:new, :create]
  resource :sessions, only: [:create, :destroy]
  resources :users, only: [:create, :edit, :update]
end
