class CommunityMembership < ApplicationRecord
  belongs_to :user
  belongs_to :community

  enum role: { member: 0, sub_admin: 1, admin: 2 }
  enum status: { pending: 0, approved: 1, rejected: 2 }

  validates :user_id, uniqueness: { scope: :community_id }

  validate :approved_is_unique_per_user_and_community

  private

  def approved_is_unique_per_user_and_community
    return unless approved?

    if CommunityMembership.where(
        user_id: user_id,
        community_id: community_id,
        status: :approved
      ).where.not(id: id).exists?

      errors.add(:base, "すでに承認済みです")
    end
  end
end
