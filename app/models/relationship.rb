# frozen_string_literal: true

class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  validates :follower_id, presence: true
  validates :followed_id, presence: true

  after_create :create_follow_notification

  private

  def create_follow_notification
    Notification.create(
      recipient: followed,
      actor: follower,
      action: :follow,
      notifiable: self
    )
  end
end
