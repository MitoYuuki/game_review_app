class Category < ApplicationRecord
  has_many :communities
  validates :name, presence: true
end

