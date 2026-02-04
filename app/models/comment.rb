class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :body, presence: true

  after_create :create_notification

  private

  def create_notification
    # 自分の投稿にコメントされたときだけ通知
    return if post.user == user

    Notification.create(
      recipient: post.user,
      actor: user,
      action: :comment,
      notifiable: self
    )
  end
end
