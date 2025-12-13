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
  resources :users, only: [:show, :edit, :update]

  # 投稿関連
  get "home" => "posts#home"
   resources :posts do
    resources :comments, only: [:create, :destroy]
    resource :likes, only: [:create, :destroy]
  end
  
  # タグ・グループ
  resources :tags, only: [:show]
  resources :groups, only: [:show]

  # ゲストログイン
  post "/guest_sign_in", to: "sessions#guest_sign_in"
 
  

  
end
