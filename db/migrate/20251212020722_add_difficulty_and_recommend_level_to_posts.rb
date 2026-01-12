# frozen_string_literal: true

class AddDifficultyAndRecommendLevelToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :difficulty, :string
    add_column :posts, :recommend_level, :integer
  end
end
