class Notification < ApplicationRecord
  belongs_to :recipient, class_name: "User"
  belongs_to :actor, class_name: "User"
  belongs_to :notifiable, polymorphic: true

  enum action: { follow: 0, comment: 1, like: 2, community_request: 3, community_approved: 4 }

  # 通知の遷移先を返す
  def redirect_path
    helpers = Rails.application.routes.url_helpers

    case action
    when "comment", "like"
      # Comment / Like → Post に飛ぶ
      helpers.post_path(notifiable.post)

    when "follow"
      # フォロー → フォローされたユーザのプロフィールへ
      helpers.user_path(actor)

    when "community_request", "community_approved"
      # 参加申請系 → Community に飛ぶ
      helpers.community_path(notifiable.community)

    else
      helpers.notifications_path
    end
  end
end