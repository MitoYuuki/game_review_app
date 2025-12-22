class LikesController < ApplicationController
  before_action :set_post
  before_action :reject_guest_user

  def create
    current_user.likes.create(post_id: @post.id)

    respond_to do |format|
      format.html { redirect_to @post }
    end
  end

  def destroy
    current_user.likes.find_by(post_id: @post.id)&.destroy

    respond_to do |format|
      format.html { redirect_to @post }
    end
  end

  private
  def set_post
    @post = Post.find(params[:post_id])
  end

  def reject_guest_user
    if current_user.nil?
      flash[:alert] = "この操作をするにはログインが必要です"
      redirect_to new_user_session_path
    end
  end
end
