# frozen_string_literal: true

class ChangeRateToFloatInPosts < ActiveRecord::Migration[6.1]
  def change
    change_column :posts, :rate, :float
  end
end
