# frozen_string_literal: true

class Group < ApplicationRecord
  has_many :posts, dependent: :destroy
end
