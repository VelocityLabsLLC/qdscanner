class Group < ApplicationRecord
  resourcify
  rolify :role_cname => 'GroupRole'
  after_create :assign_default_role
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  belongs_to :organization
  has_many :animals
  
  validates :name, presence: true
  validates :description, presence: true
  validates :owner_id, presence: true
  validates :organization_id, presence: true
  
  def assign_default_role
    self.add_role(:newgroup) if self.roles.blank?
  end
end
