# frozen_string_literal: true

class User < ApplicationRecord
  # レビュー関係
  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_one_attached :profile_image

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :is_public, inclusion: { in: [true, false] }

  enum role: { user: 0, admin: 1, guest: 2 }
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # コミュニティ関係
  has_many :owned_communities, class_name: "Community", foreign_key: "owner_id"

  has_many :community_memberships, dependent: :destroy
  has_many :topic_comments, dependent: :destroy
  has_many :topics
  has_many :comments

  # 承認済みのメンバーシップのみ
  has_many :approved_community_memberships,
          -> { where(status: :approved) },
          class_name: "CommunityMembership"

  # 参加中コミュニティのみ
  has_many :joined_communities,
          through: :approved_community_memberships,
          source: :community

  # 共通
  # 自分がフォローしているユーザー
  has_many :active_relationships, class_name: "Relationship",
                                  foreign_key: "follower_id",
                                  dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed

  # 自分をフォローしているユーザー
  has_many :passive_relationships, class_name: "Relationship",
                                   foreign_key: "followed_id",
                                   dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower

  # 自分宛の通知
  has_many :notifications, foreign_key: :recipient_id, dependent: :destroy

  # 自分が行動したことによる通知（フォローした、コメントしたなど）
  has_many :sent_notifications, class_name: "Notification", foreign_key: :actor_id, dependent: :destroy


  # フォローする
  def follow(other_user)
    return if self == other_user
    return if following?(other_user)
    
    Relationship.create!(follower_id: self.id, followed_id: other_user.id)
    reload
  end

  # フォロー解除
  def unfollow(other_user)
    relationship = active_relationships.find_by(followed_id: other_user.id)
    relationship&.destroy!
    reload
  end

  # フォローしているか？
  def following?(other_user)
    active_relationships.exists?(followed_id: other_user.id)
  end

  def get_profile_image
    if profile_image.attached?
      profile_image
    else
      "default-image.png" # publicフォルダに置くデフォルト画像
    end
  end

  def self.guest
    find_or_create_by!(email: "guest@example.com") do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲストユーザー"
      user.role = :guest
    end
  end

  def guest?
    email == "guest@example.com"
  end

  private
end
