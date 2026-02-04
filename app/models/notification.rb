class Notification < ApplicationRecord
  belongs_to :recipient, class_name: "User"
  belongs_to :actor, class_name: "User"
  belongs_to :notifiable, polymorphic: true

  enum action: { follow: 0, comment: 1, like: 2, community_request: 3, community_approved: 4 }
end
