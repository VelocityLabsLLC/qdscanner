class Group < ApplicationRecord
  has_many :memberships
  has_many :users, through: :memberships
  attr_accessible :name, :description, :isPublic, :tag_list, :owner
end
