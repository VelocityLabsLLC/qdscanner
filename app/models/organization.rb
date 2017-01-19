class Organization < ApplicationRecord
  has_many :groups
  has_many :users
  
  resourcify
end
