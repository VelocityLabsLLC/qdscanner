class CreateGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :groups do |t|
      t.string  :name
      t.string  :description
      t.integer :owner_id
      t.references :organization
      t.timestamps
    end
  end
end
