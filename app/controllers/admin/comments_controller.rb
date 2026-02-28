class Admin::CommentsController < Admin::BaseController
  def destroy
    @comment = Comment.find_by(id: params[:id])
    
    unless @comment
    redirect_to admin_posts_path, alert: "コメントが見つかりません"
    return
  end

  @post = @comment.post

  if @comment.destroy
    redirect_to admin_post_path(@post), notice: "コメントを削除しました"
  else
    redirect_to admin_post_path(@post), alert: "コメントの削除に失敗しました"
  end
end
