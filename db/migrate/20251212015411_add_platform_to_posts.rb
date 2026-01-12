# frozen_string_literal: true

class AddPlatformToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :platform, :string
  end
end
