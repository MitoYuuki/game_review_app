class Post < ApplicationRecord
  belongs_to :user
  belongs_to :group
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  attr_accessor :tag_names
  validates :group_id, presence: true

  before_save :round_rate

  def round_rate
    return if rate.nil?
    self.rate = (rate * 2).round / 2.0
  end
end
