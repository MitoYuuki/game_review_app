class CommentsController < ApplicationController
  before_action :set_post
  before_action :reject_guest_user, only: :create

  def create
    @comment = @post.comments.new(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_to @post, notice: "コメントを追加しました"
    else
      redirect_to @post, alert: "コメントを入力してください"
    end
  end

  def destroy
    comment = Comment.find(params[:id])

    # 自分のコメント以外は削除不可
    if comment.user == current_user
      comment.destroy
    end

    redirect_to post_path(comment.post)
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
