class CommunitiesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_action :set_community, only: [:show, :edit, :update, :destroy]
  before_action :ensure_owner!, only: [:edit, :update, :destroy]

  #@community に入れておくための共通化したメソッド
  def set_community
    @community = Community.find(params[:id])
  end

  def index
    @communities = Community.order(created_at: :desc)
    @categories = Category.all
  end

  def new
    @community = Community.new
  end

  def create
    @community = current_user.owned_communities.build(community_params)

    if @community.save
      # 作成者を自動参加させる
      @community.members << current_user
      redirect_to @community, notice: "コミュニティを作成しました"
    else
      render :new
    end
  end

  def show
    @community = Community.find(params[:id])
    @topics = @community.topics.order(created_at: :desc)
  end


  def members
    @community = Community.find(params[:id])
    @members = @community.members
  end

  def edit
    @community = Community.find(params[:id])
  end

  def update
    @community = Community.find(params[:id])
    if @community.update(community_params)
      redirect_to @community, notice: "コミュニティを更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  #トピック作成者のみトピックの編集可能
  def ensure_owner!
    unless @community.owner == current_user
      redirect_to community_path(@community), alert: "作成者のみ編集できます。"
    end
  end

  def destroy
    @community = Community.find(params[:id])

    unless current_user == @community.owner
      redirect_to community_path(@community), alert: "削除権限がありません。"
      return
    end

    @community.destroy
    redirect_to communities_path, notice: "コミュニティを削除しました。"
  end

  private

  def community_params
    params.require(:community).permit(
      :name,
      :description,
      :is_public,
      :category_id
    )
  end


end
