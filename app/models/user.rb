class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_one_attached :profile_image

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?
  
  enum role: { user: 0, admin: 1, guest: 2 }
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def get_profile_image
    if profile_image.attached?
      profile_image
    else
      "default-image.png" # publicフォルダに置くデフォルト画像
    end
  end

   private
  
  # パスワードが必要な場合を判断
  def password_required?
    # 新規登録時、またはパスワード変更時にのみバリデーション
    new_record? || password.present? || password_confirmation.present?
  end

end
