class CreateOrganizations < ActiveRecord::Migration[5.0]
  def change
    create_table :organizations do |t|
      t.string  :name
      t.integer  :owner_id
      t.timestamps
    end
  end
end
