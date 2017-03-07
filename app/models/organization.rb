class Organization < ApplicationRecord
  has_many :groups
  has_many :users, dependent: :nullify
  has_many :animals, through: :groups
  has_many :cages, through: :groups
  
  validates :name, presence: true
  resourcify
  

end
