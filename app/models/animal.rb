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
  
  def organization
    cage.organization
  end
  
  def group
    cage.group
  end
  
  delegate :organization, :organization_id, to: :cage
  delegate :group, :group_id, to: :cage
  
  # validates :type, presence: true
  # validates :name, presence: true
end
