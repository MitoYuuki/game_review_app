# frozen_string_literal: true

class AddStatusToCommunityMemberships < ActiveRecord::Migration[6.1]
  def change
    add_column :community_memberships, :status, :integer, default: 0, null: false
  end
end
