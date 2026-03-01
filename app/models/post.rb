# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :user
  belongs_to :group

  has_one_attached :image

  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  # タグ名の入力を受け取るための仮属性。実際のタグは tags/post_tags に保存される。
  attr_accessor :tag_names

  validates :group_id, presence: true
  validates :title, presence: true
  validates :platform, presence: true
  validates :play_time, presence: true
  validates :difficulty, presence: true
  validates :recommend_level, presence: true

  scope :published, -> { where(published: true) }
  scope :drafts, -> { where(published: false) }

  before_save :round_rate

  #評価の星の表示
  def round_rate
    return if rate.nil?
    self.rate = (rate * 2).round / 2.0
  end
end
