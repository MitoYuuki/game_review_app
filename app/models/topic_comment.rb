class TopicComment < ApplicationRecord
  belongs_to :topic
  belongs_to :user

  validates :body, presence: true, length: { maximum: 1000 }

  # ----------------------------------------
  # コメントに対しての管理
  # ----------------------------------------
  def manageable_by?(user)
    return false unless user

    return true if user.admin?
    return true if topic.community.owner_id == user.id
    return true if self.user_id == user.id

    false
  end
end
