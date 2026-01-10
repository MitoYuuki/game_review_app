# frozen_string_literal: true

class CreatePostTags < ActiveRecord::Migration[6.1]
  def change
    create_table :post_tags do |t|
      t.references :post, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true
      t.index [:post_id, :tag_id], unique: true
      t.timestamps
    end
  end
end
