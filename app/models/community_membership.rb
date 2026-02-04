class CommunityMembership < ApplicationRecord
  belongs_to :user
  belongs_to :community

  enum role: { member: 0, sub_admin: 1, admin: 2 }
  enum status: { pending: 0, approved: 1, rejected: 2 }

  validates :user_id, uniqueness: { scope: :community_id }

  validate :approved_is_unique_per_user_and_community

  #参加申請時（コミュニティオーナーへ通知）
  after_create :notify_owner_if_pending

  def notify_owner_if_pending
    return unless status == "pending" # 承認待ちの場合のみ

    Notification.create(
      recipient: community.owner, # コミュニティのオーナー
      actor: user,                # 申請したユーザー
      action: :community_request, # 新しく action を追加する
      notifiable: self            # CommunityMember レコードを参照
    )
  end

  #承認時（申請ユーザーへ通知）
  after_update :notify_user_if_approved

  def notify_user_if_approved
    return unless saved_change_to_status? && status == "approved"

    Notification.create(
      recipient: user,            # 申請ユーザー
      actor: community.owner,     # 承認したオーナー
      action: :community_approved,
      notifiable: self
    )
  end

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
