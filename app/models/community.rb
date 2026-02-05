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

  # ✅ 承認方式が変わったときに pending を自動承認
  after_update :auto_approve_pending_memberships, if: :saved_change_to_approval_type?

  private

  def auto_approve_pending_memberships
    return unless approval_type == "auto"  # manual → auto の場合のみ

    pending_memberships = community_memberships.where(status: "pending")
    pending_memberships.update_all(status: "approved", approved_at: Time.current)
  end
end
