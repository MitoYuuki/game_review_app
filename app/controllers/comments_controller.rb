# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_post
  before_action :set_comment, only: :destroy
  before_action :reject_guest_user, only: :create
  before_action :authorize_destroy!, only: :destroy

  def create
    @comment = @post.comments.build(comment_params.merge(user: current_user))

    if @comment.save
      redirect_to @post, notice: "コメントを追加しました"
    else
      redirect_to @post, alert: "コメントを入力してください"
    end
  end

  def destroy
    @comment.destroy
    redirect_to @post, notice: "コメントを削除しました"
  end

  private
    def set_post
      @post = Post.find(params[:post_id])
    end

    def set_comment
      @comment = @post.comments.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:body)
    end

    def reject_guest_user
      if current_user&.guest?
        redirect_to post_path(params[:post_id]), alert: "ゲストユーザーはコメントできません"
      end
    end

    def authorize_destroy!
      unless @comment.user == current_user
        redirect_to @post, alert: "自分のコメントのみ削除できます"
      end
    end
end
