Rails.application.routes.draw do

  # トップページ
  root to: "homes#top"

  # Devise ルーティング
  devise_for :users, controllers: {
    registrations: 'users/registrations'
    }

  devise_scope :user do
    get 'account/edit', to: 'users/registrations#edit_account', as: :edit_account
    patch 'account/update', to: 'users/registrations#update_account', as: :update_account
  end

  # ユーザー詳細・編集
  resources :users, only: [:show, :edit, :update] do
  # いいねした投稿一覧用のカスタムアクション
    get 'liked_posts', on: :member

    # フォロー / フォロワー一覧
    member do
      get :following   # /users/:id/following
      get :followers   # /users/:id/followers
    end
  end

  # 投稿関連
  get "home" => "posts#home"
   resources :posts do
    resources :comments, only: [:create, :destroy]
    resource :likes, only: [:create, :destroy]
  end
  
  # タグ・グループ
  resources :tags, only: [:show, :index]
  resources :groups, only: [:show, :index]
  get "search", to: "searches#search"

  # 管理者側
  devise_for :admins,
    path: 'admin',
    controllers: {
      sessions: 'admin/sessions'
    }

  namespace :admin do
    root to: "users#index"
    resources :users, only: [:index, :show, :destroy]

    resources :posts, only: [:index, :show, :destroy]
  end

  # ゲストログイン
  devise_scope :user do
    post "/guest_sign_in", to: "users/sessions#guest_sign_in"
  end

  # フォローフォロワー
  resources :relationships, only: [:create, :destroy]

end
