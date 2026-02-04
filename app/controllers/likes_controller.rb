# frozen_string_literal: true

class LikesController < ApplicationController
  before_action :set_post
  before_action :reject_guest_user
  before_action :authenticate_user!

  def create
    @like = current_user.likes.create(post_id: @post.id)

    respond_to do |format|
      format.js   # JavaScript形式のレスポンスを追加
      format.html { redirect_to @post }
    end
  end

  def destroy
    @like = current_user.likes.find_by(post_id: @post.id)
    @like&.destroy

    respond_to do |format|
      format.js   # JavaScript形式のレスポンスを追加
      format.html { redirect_to @post }
    end
  end

  private
    def set_post
      @post = Post.find(params[:post_id])
    end

    def reject_guest_user
      if current_user&.guest?
        respond_to do |format|
          format.js do
            render js: "alert('ゲストユーザーはいいねできません');"
          end
          format.html do
            redirect_back fallback_location: root_path,
              alert: "ゲストユーザーはいいねできません"
          end
        end
      end
    end
end
