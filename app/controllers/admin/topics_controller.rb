# frozen_string_literal: true

class Admin::TopicsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_community
  before_action :set_topic, only: [:show, :destroy]

  def index
    @topics = @community.topics
  end

  def show
    @topic = @community.topics.find(params[:id])
    @comments = @topic.topic_comments.includes(:user)
  end

  def destroy
    @community = Community.find(params[:community_id])
    @topic = @community.topics.find(params[:id])
    @topic.destroy
    redirect_to admin_community_topics_path(@community),
      notice: "トピックを削除しました"
  end

  private
    def set_community
      @community = Community.find(params[:community_id])
    end

    def set_topic
      @topic = @community.topics.find(params[:id])
    end
end
