Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  root "home#index"

  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  resources :users, only: [ :show ] do
    resources :reviews, only: [ :create ]
  end

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  get "/dashboard", to: "dashboard#index"

  get "/my-purchases", to: "purchases#index", as: :my_purchases

  resource :account, only: [ :show, :edit, :update ]

  resources :bundles, only: [ :index, :new, :create, :show ] do
    resources :bundle_purchases, only: [ :create ]
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "sw" => "rails/pwa#service_worker", as: :pwa_sw
  get "sw.js" => "rails/pwa#service_worker"

  # Defines the root path route ("/")
  # root "posts#index"
end
