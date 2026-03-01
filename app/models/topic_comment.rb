# frozen_string_literal: true

class TopicComment < ApplicationRecord
  belongs_to :topic
  belongs_to :user

  validates :body, presence: true, length: { maximum: 1000 }

  # ----------------------------------------
  # コメントに対しての管理
  # ----------------------------------------
  def manageable_by?(user)
    return false unless user

    # コメントを管理できるユーザーか判定
    user.admin? ||  # - 管理者
    topic.community.owner_id == user.id ||  # - コミュニティのオーナー
    user_id == user.id  # - コメントの投稿者

    false
  end
end
