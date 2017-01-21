class Organization < ApplicationRecord
  has_many :groups
  has_many :users, dependent: :nullify
  validates :name, presence: true
  resourcify
end
