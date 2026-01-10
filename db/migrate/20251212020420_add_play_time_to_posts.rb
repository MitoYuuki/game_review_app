# frozen_string_literal: true

class AddPlayTimeToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :play_time, :string
  end
end
