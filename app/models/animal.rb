class Animal < ApplicationRecord
  resourcify
  enum status: {
    healthy: 0,
    sick: 1,
    deceased: 2
  }
  # belongs_to :group
  belongs_to :user
  belongs_to :cage
  
  # def organization
  #   cage.organization
  # end
  
  # def group
  #   cage.try(:group)
  # end
  
  delegate :organization, :organization_id, to: :cage, :allow_nil => true
  delegate :group, :group_id, to: :cage, :allow_nil => true
  
end
