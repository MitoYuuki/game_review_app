# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :reject_guest_user, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]

  # トップページ
  def home
    if params[:keyword].present?
      @posts = Post.where("title LIKE ?", "%#{params[:keyword]}%")
    else
      @posts = Post.order(created_at: :desc).limit(10)
    end

    @groups = Group.all
    @tags   = Tag.all
  end

  def index
    @posts = Post.published.includes(:user, :group, :tags, :likes, :comments)
    @groups = Group.all
    @tags   = Tag.all

    case params[:sort]
    when "rate"
      @posts = @posts.order(rate: :desc)
    when "likes"
      @posts = @posts.left_joins(:likes).group(:id).order("COUNT(likes.id) DESC")
    when "comments"
      @posts = @posts.left_joins(:comments).group(:id).order("COUNT(comments.id) DESC")
    when "platform"
      @posts = @posts.order(:platform) # 昇順。必要なら desc にもできる
    else
      @posts = @posts.order(created_at: :desc)
    end

    # ページネーション
    @posts = @posts.page(params[:page]).per(10)
  end



  def show
    unless @post.published? || @post.user == current_user
      redirect_to root_path, alert: "この投稿は非公開です"
    end

    # ★ 閲覧数を 1 増やす（投稿者は除外）
    if user_signed_in?
      @post.increment!(:views) unless current_user == @post.user
    else
      @post.increment!(:views)
    end
  end

  def new
    @post   = Post.new
    @groups = Group.all
    @tags   = Tag.all
  end

  def edit
    @groups = Group.all
    @tags   = Tag.all
  end

  def create
    @post = current_user.posts.new(post_params)

    if @post.save
      redirect_to @post, notice: "投稿を作成しました"
    else
      @groups = Group.all
      @tags   = Tag.all
      render :new
    end
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: "投稿を更新しました"
    else
      @groups = Group.all
      @tags   = Tag.all
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: "レビューを削除しました。"
  end

  private
    def reject_guest_user
      if current_user.guest?
        redirect_to root_path, alert: "ゲストユーザーは投稿できません"
      end
    end

    def set_post
      @post = Post.find(params[:id])
    end

    def correct_user
      redirect_to posts_path, alert: "権限がありません。" unless @post.user == current_user
    end

    def post_params
      params.require(:post).permit(
        :platform,
        :group_id,
        :title,
        :rate,
        :body,
        :play_time,
        :difficulty,
        :recommend_level,
        :published,
        :image,
        tag_ids: []
      )
    end
end
