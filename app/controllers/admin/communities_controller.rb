class Admin::CommunitiesController < ApplicationController
  before_action :authenticate_admin!

  def index
    @communities = Community.all.includes(:owner)
  end

  def show
    @community = Community.find(params[:id])
    @topics = @community.topics
  end

  def destroy
    @community = Community.find(params[:id])
    @community.destroy
    redirect_to admin_communities_path, notice: "コミュニティを削除しました"
  end
end