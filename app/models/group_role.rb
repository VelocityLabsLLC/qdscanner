class GroupRole < ApplicationRecord
  has_and_belongs_to_many :groups, :join_table => :groups_group_roles

  belongs_to :resource,
             :polymorphic => true,
             :optional => true

  validates :resource_type,
            :inclusion => { :in => Rolify.resource_types },
            :allow_nil => true

  scopify
end
