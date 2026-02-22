# frozen_string_literal: true

class CommunitiesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy, :members]
  before_action :restrict_guest_actions, only: [:new, :create]
  before_action :set_community, only: [:show, :edit, :update, :destroy, :members]
  before_action :ensure_owner!, only: [:edit, :update, :destroy]

  # 一覧
  def index
    @communities = Community.order(created_at: :desc)
                            .page(params[:page])
                            .per(5)
    @categories  = Category.all
  end

  # 新規作成
  def new
    @community = Community.new
  end

  def create
    @community = current_user.owned_communities.build(community_params)

    if @community.save
      @community.members << current_user
      redirect_to @community, notice: "コミュニティを作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # 詳細
  def show
    @topics = @community.topics.order(created_at: :desc)

    if user_signed_in?
      @membership = CommunityMembership.find_by(
        community: @community,
        user: current_user
      )
    end
  end

  # メンバー一覧
  def members
    @members = @community.members
  end

  # 編集
  def edit
  end

  def update
    if @community.update(community_params)
      redirect_to @community, notice: "コミュニティを更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # 削除
  def destroy
    @community.destroy
    redirect_to communities_path, notice: "コミュニティを削除しました。"
  end

  private
    # ゲスト制限
    def restrict_guest_actions
      restrict_user!(
        condition: current_user.guest?,
        redirect_path: communities_path,
        message: "ゲストユーザーはこの操作はできません"
      )
    end

    # 共通：コミュニティ取得
    def set_community
      @community = Community.find(params[:id])
    end

    # 作成者チェック
    def ensure_owner!
      return if @community.owner == current_user

      redirect_to community_path(@community),
                  alert: "作成者のみ編集・削除できます。"
    end

    # Strong Parameters
    def community_params
      params.require(:community).permit(
        :name,
        :description,
        :category_id,
        :approval_type,
        :image
      )
    end

end
