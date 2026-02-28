# frozen_string_literal: true

class Admin::CommunitiesController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_community, only: [:show, :destroy]

  def index
    @communities = Community
                     .includes(:owner)
                     .order(:id)
                     .page(params[:page])
                     .per(10)
  end

  def show
    @topics = @community.topics
  end

  def destroy
    if @community.destroy
      redirect_to admin_communities_path, notice: "コミュニティを削除しました"
    else
      redirect_to admin_communities_path, alert: "削除に失敗しました"
    end
  end

  private

  def set_community
    @community = Community.find(params[:id])
  end
end
