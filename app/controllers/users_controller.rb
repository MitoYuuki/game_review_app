# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :following, :followers]
  before_action :authenticate_user!, except: [:new, :create, :guest_sign_in]
  before_action :restrict_guest_actions, only: [:edit, :update]

  def guest_sign_in
    user = User.guest
    sign_in user
    redirect_to root_path, notice: "ゲストログインしました"
  end

  def show
    @topics = @user.topics.order(created_at: :desc)

    # ▼ 投稿（公開・非公開の制御）
    if current_user == @user
      @posts = @user.posts.order(created_at: :desc)
    else
      @posts = @user.posts.published.order(created_at: :desc)
    end

    # ▼ 参加中コミュニティ取得
    if current_user == @user
      # 自分のページ: 承認済み＋承認待ち
      @joined_communities = Community.joins(:community_memberships)
                                    .where(community_memberships: { user_id: @user.id })
    else
      # 他人のページ: 承認済みのみ
      @joined_communities = @user.joined_communities
    end
  end


  def edit
    @user = User.find(params[:id])
  end

  def update
    # パスワードが空の場合はパラメータから削除
    if user_params[:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    if @user.update(user_params)
      # パスワードを変更した場合は再ログインが必要になることがある
      if user_params[:password].present?
        bypass_sign_in(@user)
      end
      redirect_to @user, notice: "プロフィールを更新しました"
    else
      # エラーメッセージを表示
      flash.now[:alert] = @user.errors.map(&:message).uniq.join(", ")
      render :edit
    end
  end

  # いいねした投稿一覧
  def liked_posts
    @user = User.find(params[:id])
    # likesテーブルを通して投稿を取得
    @liked_posts = @user.likes.includes(:post).map(&:post)
  end

  # フォローしている人一覧
  def following
    @users = @user.following
  end

  # フォロワー一覧
  def followers
    @users = @user.followers
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :profile, :profile_image, :email, :password, :password_confirmation, :is_public)
    end

    def restrict_guest_actions
      restrict_user!(
        condition: current_user.guest?,
        redirect_path: root_path,
        message: "ゲストユーザーはこの操作はできません"
      )
    end
end
