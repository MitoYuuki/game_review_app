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
      # Post が削除されていたら notifications に戻す
      return helpers.notifications_path if notifiable&.post.nil?
      
      helpers.post_path(notifiable.post)

    when "follow"
      # フォロー → フォローされたユーザのプロフィールへ
      helpers.user_path(actor)

    when "community_request", "community_approved"
      # notifiable が nil（CommunityMembership消滅）、
      # または関連する community が nil（コミュニティ削除）のときに備える
      return helpers.notifications_path if notifiable.nil? || notifiable.community.nil?

      helpers.community_path(notifiable.community)

    else
      helpers.notifications_path
    end
  end
end