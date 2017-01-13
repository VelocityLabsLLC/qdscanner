class Organization < ApplicationRecord
  has_many :groups
  
  resourcify
end
