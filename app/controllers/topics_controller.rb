class TopicsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_community
  before_action :set_topic, only: [:show, :edit, :update, :destroy]
  before_action :require_membership, only: [:new, :create]

  # トピック管理権限
  # 投稿者 / コミュニティオーナー / 管理者
  before_action :ensure_topic_manageable!, only: [:edit, :update, :destroy]

  def index
    @topics = @community.topics.includes(:user).order(created_at: :desc)
  end

  def show
    @topic_comments = @topic.topic_comments.includes(:user)
    @topic_comment = TopicComment.new
    @comments = @topic.topic_comments.includes(:user).order(created_at: :desc)
  end

  def new
    @topic = @community.topics.new
  end

  def create
    @topic = @community.topics.new(topic_params)
    @topic.user = current_user

    if @topic.save
      redirect_to community_topic_path(@community, @topic), notice: "トピックを作成しました"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @topic.update(topic_params)
      redirect_to community_topic_path(@community, @topic), notice: "トピックを更新しました"
    else
      render :edit
    end
  end

  def destroy
    @topic.destroy
    redirect_to community_topics_path(@community), notice: "トピックを削除しました"
  end


  private

  def set_community
    @community = Community.find(params[:community_id])
  end

  def set_topic
    @topic = @community.topics.find(params[:id])
  end

  def topic_params
    params.require(:topic).permit(:title, :body)
  end

  # 参加者のみトピック作成可
  def require_membership
    unless @community.members.exists?(current_user.id)
      redirect_to @community, alert: "まずコミュニティに参加してください"
    end
  end

  # ===============================
  #  トピック管理権限
  #  投稿者 / owner / admin
  # ===============================
  def ensure_topic_manageable!
    community_owner_id = @community.owner_id

    unless (
      @topic.user_id == current_user.id ||        # トピック投稿者
      community_owner_id == current_user.id ||    # コミュニティオーナー
      current_user.admin?                         # サイト管理者
    )
      redirect_to community_topic_path(@community, @topic), alert: "権限がありません"
    end
  end
end
