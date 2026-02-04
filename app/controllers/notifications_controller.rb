class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.notifications
      .includes(:actor, :notifiable)  # ← ここだけで十分！
      .order(created_at: :desc)
  end

  def show
    @notification = current_user.notifications.find(params[:id])

    # 未読の場合は既読にする
    @notification.update(read: true) unless @notification.read

    # 種類ごとに遷移先を切り替え
    path =
      case @notification.action

      when "comment"
        # Comment → post に飛ぶ
        post_path(@notification.notifiable.post)

      when "like"
        # Like → post に飛ぶ
        post_path(@notification.notifiable.post)

      when "follow"
        # フォローした相手のプロフィールへ
        user_path(@notification.actor)

      when "community_request", "community_approved"
        # community_membership → community に飛ぶ
        community_path(@notification.notifiable.community)

      else
        notifications_path
      end

    redirect_to path
  end

  #既読ボタン
  def mark_all_as_read
    current_user.notifications.update_all(read: true)
    redirect_to notifications_path, notice: "すべて既読にしました！"
  end

  #既読削除ボタン
  def delete_read
    current_user.notifications.where(read: true).destroy_all
    redirect_to notifications_path, notice: "既読通知を削除しました！"
  end

end
