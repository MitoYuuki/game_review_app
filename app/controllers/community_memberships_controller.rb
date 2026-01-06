class CommunityMembershipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_community

  def create
    @community.members << current_user unless @community.members.include?(current_user)
    redirect_to @community, notice: "コミュニティに参加しました"
  end

  def destroy
    membership = @community.community_memberships.find_by(user: current_user)
    membership&.destroy
    redirect_to @community, notice: "コミュニティを退会しました"
  end

  private

  def set_community
    @community = Community.find(params[:community_id])
  end
end
