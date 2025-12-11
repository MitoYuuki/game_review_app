class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post

  # 1ユーザー1投稿につき1回しかいいねできない
  validates :user_id, uniqueness: { scope: :post_id }
end
