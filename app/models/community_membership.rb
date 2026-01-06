class CommunityMembership < ApplicationRecord
  belongs_to :user
  belongs_to :community

  enum role: { member: 0, sub_admin: 1, admin: 2 }

  validates :user_id, uniqueness: { scope: :community_id }
end
