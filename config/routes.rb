Rails.application.routes.draw do
  # Defines the root path route ("/")
  root "sessions#new"

  # Below is the expanded syntax of the rails short hand:
  # resource :session
  # Session routes (singular resource)
  get "session/new", to: "sessions#new", as: :new_session
  post "session", to: "sessions#create", as: :session
  delete "session", to: "sessions#destroy"
  get "logged_in", to: "sessions#logged_in"


  # Below is the expanded syntax of the rails short hand:
  # resources :users
  # User routes (web)
  get "users/new", to: "users#new", as: :new_user
  post "users", to: "users#create", as: :users
  get "users/:id", to: "users#show", as: :user

  # API Routes
  namespace :api do
    namespace :v1 do
      post 'auth/login', to: 'auth#login'
      post 'auth/refresh', to: 'auth#refresh'

      # API User routes
      # Expanded syntax instead of resources :users, only: [:show, :create, :update]
      get 'users/:id', to: 'users#show'
      post 'users', to: 'users#create'
      patch 'users/:id', to: 'users#update'
      put 'users/:id', to: 'users#update'
    end
  end
end
