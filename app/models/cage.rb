class Cage < ApplicationRecord
  resourcify
  enum gender: {
    male: 0,
    female: 1
  }
  
  belongs_to :group
  belongs_to :user
  has_many :animals
  
  # def organization
  #   group.organization
  # end
  
  delegate :organization, :organization_id, to: :group, :allow_nil => true
end
