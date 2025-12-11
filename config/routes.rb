Rails.application.routes.draw do
  #get 'homes/top'
  root to: "homes#top"
  get "home" => "posts#home"
  resources :posts
  devise_for :users
  post "/guest_sign_in", to: "sessions#guest_sign_in"
  resources :posts do
    resources :comments, only: [:create, :destroy]
    resource :like, only: [:create, :destroy]
  end
  resources :tags, only: [:show]
  resources :groups, only: [:show]
end
