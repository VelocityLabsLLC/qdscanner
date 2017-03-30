class CreateAnimals < ActiveRecord::Migration[5.0]
  def change
    create_table :animals do |t|
      t.string      :identifier
      t.string      :species
      t.string      :strain
      t.integer     :status, default: 0
      t.references  :user, foreign_key: true
      t.references  :cage, foreign_key: true
      t.timestamps
    end
  end
end
