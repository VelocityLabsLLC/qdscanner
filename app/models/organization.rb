class Organization < ApplicationRecord
  has_many :groups
  has_many :users
  validates :name, presence: true
  resourcify
end
