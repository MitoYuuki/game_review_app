class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post

  # 1ユーザー1投稿につき1回しかいいねできない
  validates :user_id, uniqueness: { scope: :post_id }

  has_one :notification, as: :notifiable, dependent: :destroy

  after_create :create_notification

  private

  def create_notification
    # 投稿者自身が自分の投稿にいいねしても通知しない
    return if post.user_id == user_id

    Notification.create!(
      recipient_id: post.user_id,   # 通知を受け取る人（投稿者）
      actor_id: user_id,       # 通知を発生させた人（いいねした人）
      action: "like",
      notifiable: self
    )
  end
end
