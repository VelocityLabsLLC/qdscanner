class Animal < ApplicationRecord
  resourcify
  enum status: {
    healthy: 0,
    sick: 1,
    deceased: 2
  }
  belongs_to :group
  belongs_to :user
  belongs_to :cage
  
  def organization
    group.organization
  end
  
  delegate :organization, :organization_id, to: :group
  # validates :type, presence: true
  # validates :name, presence: true
end
