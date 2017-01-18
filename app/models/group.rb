class Group < ApplicationRecord
  resourcify
  rolify :role_cname => 'GroupRole'
  after_create :assign_default_role
  has_many :memberships
  has_many :users, through: :memberships
  belongs_to :organization
  # has_many :animals
  
  def assign_default_role
    self.add_role(:newgroup) if self.roles.blank?
  end
end
