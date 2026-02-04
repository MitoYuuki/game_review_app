# frozen_string_literal: true

class Admin::TopicCommentsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_community
  before_action :set_topic

  def destroy
    comment = @topic.topic_comments.find(params[:id])
    comment.destroy

    redirect_to admin_community_topic_path(@community, @topic),
                notice: "コメントを削除しました"
  end

  private
    def set_community
      @community = Community.find(params[:community_id])
    end

    def set_topic
      @topic = @community.topics.find(params[:topic_id])
    end
end
