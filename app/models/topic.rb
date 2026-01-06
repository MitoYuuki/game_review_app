class Topic < ApplicationRecord
  # 所属コミュニティ
  belongs_to :community
  # 投稿者
  belongs_to :user
  # トピックに紐づくコメント
  has_many :topic_comments, dependent: :destroy

  # ----------------------------------------
  # バリデーション
  # ----------------------------------------
  validates :title, presence: true, length: { maximum: 50 }
  validates :body,  presence: true, length: { maximum: 1000 }

  # ----------------------------------------
  # 並び替え用スコープ
  # ----------------------------------------
  scope :recent, -> { order(created_at: :desc) }

  # ----------------------------------------
  # トピックの管理
  # ----------------------------------------
  # 管理権限チェック
  def manageable_by?(user)
    return false unless user

    # サイト管理者(admin)
    return true if user.admin?

    # コミュニティオーナー
    return true if community.owner_id == user.id

    # トピック投稿者
    return true if self.user_id == user.id

    false
  end
end
