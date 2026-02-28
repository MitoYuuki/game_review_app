# frozen_string_literal: true

class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_post, only: [:show, :destroy]

  def index
    @posts = Post.includes(:user).order(:id).page(params[:page]).per(10)
  end

  def show
    @comments = @post.comments.includes(:user).order(created_at: :asc)
  end

  def destroy
    @post.destroy
    redirect_to admin_posts_path, notice: "レビューを削除しました"
  end

  private
    def set_post
      @post = Post.find(params[:id])
    end
end
