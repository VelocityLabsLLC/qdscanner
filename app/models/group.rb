class Group < ApplicationRecord
  resourcify
  rolify :role_cname => 'GroupRole'
  has_many :memberships
  has_many :users, through: :memberships
  belongs_to :organization
  # has_many :animals
end
