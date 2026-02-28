# frozen_string_literal: true

class CommunityMembershipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_community
  before_action :set_membership, only: [:approve, :reject]
  before_action :reject_guest_user, only: [:create, :destroy]
  before_action :ensure_owner!, only: [:index, :approve, :reject]

  # 申請一覧（オーナーのみ）
  def index
    @pending_memberships =
      @community.community_memberships
                .includes(:user)
                .pending
                .where.not(user_id: @community.owner_id)
  end

  # 参加申請
  def create
    # オーナーは申請不可（＝常に参加中）
    if current_user == @community.owner
      redirect_to @community, alert: "オーナーは申請できません"
      return
    end

    membership = @community.community_memberships.find_or_initialize_by(
      user: current_user
    )

    if membership.persisted?
      redirect_to @community,
                  alert: "すでに申請済み、または参加済みです"
      return
    end

    membership.status =
      @community.auto? ? :approved : :pending

    if membership.save
      notice =
        @community.auto? ? "コミュニティに参加しました" : "参加申請を送信しました"
      redirect_to @community, notice: notice
    else
      redirect_to @community, alert: "参加処理に失敗しました"
    end
  end

  # 承認
  def approve
    if @membership.update(status: :approved)
      redirect_to community_community_memberships_path(@community),
                  notice: "参加を承認しました"
    else
      redirect_to community_community_memberships_path(@community),
                  alert: "承認に失敗しました"
    end
  end

  # 拒否
  def reject
    if @membership.update(status: :rejected)
      redirect_to community_community_memberships_path(@community),
                  alert: "申請を拒否しました"
    else
      redirect_to community_community_memberships_path(@community),
                  alert: "拒否処理に失敗しました"
    end
  end

  # 退会（参加済ユーザーのみ）
  def destroy
    # オーナーは退会不可
    if current_user == @community.owner
      redirect_to @community,
                  alert: "オーナーはコミュニティを退会できません"
      return
    end

    membership =
      @community.community_memberships.find_by(user: current_user)

    membership&.destroy
    redirect_to @community, notice: "コミュニティを退会しました"
  end

  private
    def set_community
      @community = Community.find(params[:community_id])
    end

    def set_membership
      @membership = @community.community_memberships.find(params[:id])
    end

    def reject_guest_user
      if current_user&.guest?
        redirect_to @community,
                    alert: "ゲストユーザーは参加できません"
      end
    end

    # コミュニティ作成者のみ許可
    def ensure_owner!
      return if @community.owner == current_user

      redirect_to root_path, alert: "権限がありません"
    end
end
