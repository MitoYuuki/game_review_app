class CommunitiesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy, :members]
  before_action :reject_guest_user, only: [:new, :create]
  before_action :set_community, only: [:show, :edit, :update, :destroy, :members]
  before_action :ensure_owner!, only: [:edit, :update, :destroy]

  # 一覧
  def index
    @communities = Community.order(created_at: :desc)
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
      :approval_type
    )
  end

  # ゲスト制限
  def reject_guest_user
    if current_user.guest?
      redirect_to communities_path,
                  alert: "ゲストユーザーはコミュニティを作成できません。"
    end
  end
end
