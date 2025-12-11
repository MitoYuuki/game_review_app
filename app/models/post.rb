class Post < ApplicationRecord
  #belongs_to :user
  #belongs_to :group
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  attr_accessor :tag_names
end
