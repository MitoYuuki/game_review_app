# frozen_string_literal: true

class Community < ApplicationRecord
  belongs_to :owner, class_name: "User"
  belongs_to :category

  has_many :community_memberships, dependent: :destroy

  # 🔽 承認済みのみ
  has_many :approved_memberships,
           -> { approved },
           class_name: "CommunityMembership"

  has_many :members,
           through: :approved_memberships,
           source: :user

  has_many :topics, dependent: :destroy

  validates :name, presence: true, length: { maximum: 50 }
  validates :description, presence: true

  enum approval_type: {
    auto: 0,      # 自動承認
    manual: 1     # 承認制
  }
end
