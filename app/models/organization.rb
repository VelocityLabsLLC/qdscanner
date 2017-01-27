class Organization < ApplicationRecord
  has_many :groups
  has_many :users, dependent: :nullify
  has_many :animals, through: :groups
  
  validates :name, presence: true
  resourcify
  

end
