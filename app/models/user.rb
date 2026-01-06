class User < ApplicationRecord
  #レビュー関係
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_one_attached :profile_image

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :is_public, inclusion: { in: [true, false] }
  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?

  enum role: { user: 0, admin: 1, guest: 2 }
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  #コミュニティ関係
  has_many :owned_communities, class_name: "Community", foreign_key: "owner_id"

  has_many :community_memberships, dependent: :destroy
  has_many :joined_communities, through: :community_memberships, source: :community
  has_many :topic_comments, dependent: :destroy


  has_many :topics
  has_many :comments

  #レビュー関係
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

  # フォローする
  def follow(other_user)
    following << other_user unless self == other_user
  end

  # フォロー解除
  def unfollow(other_user)
    following.delete(other_user)
  end

  # フォローしているか？
  def following?(other_user)
    following.include?(other_user)
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
    end
  end

  def guest?
    email == "guest@example.com"
  end

  private
    # パスワードが必要な場合を判断
    def password_required?
      # 新規登録時、またはパスワード変更時にのみバリデーション
      new_record? || password.present? || password_confirmation.present?
    end
end
