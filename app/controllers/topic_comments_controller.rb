# frozen_string_literal: true

class TopicCommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_topic
  before_action :set_topic_comment, only: [:edit, :update, :destroy]
  before_action :ensure_member!
  before_action :ensure_editable!, only: [:edit, :update, :destroy]

  def create
    @topic_comment = @topic.topic_comments.build(topic_comment_params)
    @topic_comment.user = current_user

    if @topic_comment.save
      redirect_to [@topic.community, @topic], notice: "コメントを投稿しました。"
    else
      flash.now[:alert] = "コメントを投稿できませんでした。"
      @comments = @topic.topic_comments.includes(:user)
      render "topics/show"
    end
  end

  def update
    if @topic_comment.update(topic_comment_params)
      redirect_to [@topic.community, @topic], notice: "コメントを更新しました。"
    else
      flash.now[:alert] = "コメントを更新できませんでした。"
      render :edit
    end
  end

  def destroy
    @topic_comment.destroy
    redirect_to [@topic.community, @topic], notice: "コメントを削除しました。"
  end


  private
    def set_topic
      @community = Community.find(params[:community_id])
      @topic = Topic.find(params[:topic_id])
    end

    def set_topic_comment
      @topic_comment = @topic.topic_comments.find(params[:id])
    end

    def topic_comment_params
      params.require(:topic_comment).permit(:body)
    end

    # コミュニティ参加必須
    def ensure_member!
      unless @topic.community.members.exists?(current_user.id)
        redirect_to @topic.community, alert: "コミュニティ参加者のみコメントできます。"
      end
    end

    # 権限チェック
    # ＝ 管理者 / コミュニティオーナー / コメント投稿者
    def ensure_editable!
      return if @topic_comment.user_id == current_user.id     # コメント投稿者
      return if @topic.community.owner_id == current_user.id  # コミュニティオーナー
      return if current_user.admin?                           # サイト管理者

      redirect_to [@topic.community, @topic], alert: "権限がありません。"
    end
end
