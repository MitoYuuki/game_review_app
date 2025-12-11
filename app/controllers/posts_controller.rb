class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

   # トップページ
  def home
    # 検索キーワードがある場合
    if params[:keyword].present?
      @posts = Post.where("title LIKE ?", "%#{params[:keyword]}%")
    else
      @posts = Post.order(created_at: :desc).limit(10)
    end

    @groups = Group.all   # ジャンル一覧
    @tags = Tag.all       # タグ一覧
  end

  def index
    @posts = Post.includes(:group, :tags).order(created_at: :desc)
    @groups = Group.all      # ← これがないとビューで nil になる
    @tags = Tag.all          # ← 同じく
  end

  def show
  end

  def new
    @post = Post.new
    @groups = Group.all
    @tags = Tag.all
  end

  def edit
    @groups = Group.all
    @tags   = Tag.all
  end

  def create
  @post = current_user.posts.new(post_params)
  if @post.save
      redirect_to @post, notice: "投稿を作成しました"
    else
      @groups = Group.all
      @tags   = Tag.all
    render :new
  end
end

def update
  if @post.update(post_params)
    redirect_to @post, notice: "投稿を更新しました"
    else
      @groups = Group.all
      @tags   = Tag.all
      render :edit
    end
  end

  def destroy
      @post.destroy
      redirect_to posts_path, notice: "レビューを削除しました。"
  end

private

  def set_post
    @post = Post.find(params[:id])
  end

  # ★ここ重要 — tag_ids: [] を permit に追加！
  def post_params
    params.require(:post).permit(
      :platform,
      :group_id,
      :title,
      :rating,
      :content,
      :play_time,
      :difficulty,
      :recommend_level,
      tag_ids: []   # ←タグの複数選択対応
    )
  end

end
