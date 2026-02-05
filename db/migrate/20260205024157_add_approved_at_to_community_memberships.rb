class AddApprovedAtToCommunityMemberships < ActiveRecord::Migration[6.1]
  def change
    add_column :community_memberships, :approved_at, :datetime
  end
end
