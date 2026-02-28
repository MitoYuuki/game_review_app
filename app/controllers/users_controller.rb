# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:new, :create, :guest_sign_in]
  before_action :set_user, only: [:show, :edit, :update, :following, :followers, :liked_posts]
  before_action :restrict_guest_actions, only: [:edit, :update]

  # ゲストログイン
  def guest_sign_in
    user = User.guest
    sign_in user
    redirect_to root_path, notice: "ゲストログインしました"
  end

  # ユーザー詳細
  def show
    @topics = @user.topics.order(created_at: :desc)

    # 投稿（公開・非公開の制御）
    @posts =
      if current_user == @user
        @user.posts.order(created_at: :desc)
      else
        @user.posts.published.order(created_at: :desc)
      end

    # 参加中コミュニティ取得
    @joined_communities =
      if current_user == @user
        # 自分のページ: 承認済み＋承認待ち
        Community.joins(:community_memberships)
                 .where(community_memberships: { user_id: @user.id })
      else
        # 他人のページ: 承認済みのみ
        @user.joined_communities
      end
  end

  # 編集
  def edit
  end

  # 更新
  def update
    sanitize_password_if_blank!

    if @user.update(user_params)
      bypass_sign_in(@user) if user_params[:password].present?
      redirect_to @user, notice: "プロフィールを更新しました"
    else
      flash.now[:alert] = @user.errors.full_messages.uniq.join(", ")
      render :edit
    end
  end

  # いいねした投稿一覧
  def liked_posts
    @user = User.find(params[:id])
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
      params.require(:user).permit(
        :name, :profile, :profile_image,
        :email, :password, :password_confirmation, :is_public
      )
    end

    # パスワード欄が空欄ならパスワード変更しない
    def sanitize_password_if_blank!
      return if user_params[:password].blank?

      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    def restrict_guest_actions
      restrict_user!(
        condition: current_user.guest?,
        redirect_path: root_path,
        message: "ゲストユーザーはこの操作はできません"
      )
    end
end