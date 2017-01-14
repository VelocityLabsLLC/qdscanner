class RolifyCreateGroupRoles < ActiveRecord::Migration
  def change
    create_table(:group_roles) do |t|
      t.string :name
      t.references :resource, :polymorphic => true

      t.timestamps
    end

    create_table(:groups_group_roles, :id => false) do |t|
      t.references :group
      t.references :group_role
    end

    add_index(:group_roles, :name)
    add_index(:group_roles, [ :name, :resource_type, :resource_id ])
    add_index(:groups_group_roles, [ :group_id, :group_role_id ])
  end
end
