# frozen_string_literal: true

class AddApprovalTypeToCommunities < ActiveRecord::Migration[6.1]
  def change
    add_column :communities, :approval_type, :integer, default: 0, null: false
  end
end
