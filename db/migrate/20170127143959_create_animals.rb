class CreateAnimals < ActiveRecord::Migration[5.0]
  def change
    create_table :animals do |t|
      t.string      :identifier
      t.string      :animal_type
      t.string      :strain
      t.string      :location
      t.integer     :status, default: 0
      t.references  :group, foreign_key: true
      t.references  :user, foreign_key: true
      t.timestamps
    end
  end
end
