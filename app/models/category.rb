# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :communities
  validates :name, presence: true
end
