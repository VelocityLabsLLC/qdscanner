class GroupMembership < ActiveRecord::Base
  groupify :group_membership
  has_many :invites
end
