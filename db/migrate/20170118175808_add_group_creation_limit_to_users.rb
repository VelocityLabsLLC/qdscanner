class AddGroupCreationLimitToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :group_creation_limit, :integer
  end
end
