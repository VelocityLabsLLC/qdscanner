class AddOrganizationRefToUsers < ActiveRecord::Migration[5.0]
  def change
    add_reference :users, :organization, foreign_key: true, default: 1
  end
end
