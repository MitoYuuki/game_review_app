# frozen_string_literal: true

class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post
  before_action :reject_guest_user

  def create
    @like = current_user.likes.create(post_id: @post.id)

    respond_to do |format|
      format.js   # JavaScript形式のレスポンスを追加
      format.html { redirect_to @post }
    end
  end

  def destroy
    @like = current_user.likes.find_by(post_id: @post.id)
    @like&.destroy # @like が nil ではない場合 destroy を実行

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
      return unless current_user.guest? # ゲストユーザーかどうか判定

      respond_to do |format|
        format.js   { render js: "alert('ゲストユーザーはいいねできません');" }
        format.html { redirect_back fallback_location: root_path,
                      alert: "ゲストユーザーはいいねできません" }
      end
    end
end
