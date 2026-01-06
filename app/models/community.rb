class Community < ApplicationRecord
  belongs_to :owner, class_name: "User"
  belongs_to :category

  has_many :community_memberships, dependent: :destroy
  has_many :members, through: :community_memberships, source: :user

  has_many :topics, dependent: :destroy

  validates :name, presence: true, length: { maximum: 50 }
  validates :description, presence: true
end
