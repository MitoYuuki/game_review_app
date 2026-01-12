class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @posts = Post.includes(:user).order(:id)
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments.includes(:user).order(created_at: :asc)
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to admin_posts_path, notice: "レビューを削除しました"
  end
end
