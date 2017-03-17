class CreateCages < ActiveRecord::Migration[5.0]
  def change
    create_table :cages do |t|
      t.integer     :cage_number
      t.string      :pi
      t.integer     :protocol
      t.integer     :requisition
      t.string      :cost_center
      t.string      :age_or_weight
      t.string      :species
      t.string      :s_s_b
      t.datetime    :receive_date
      t.datetime    :transfer_date
      t.datetime    :birth_date
      t.integer     :gender, default: 0
      t.integer     :total_animals
      t.string      :location
      t.string      :vendor
      t.string      :emergency_num
      t.string      :comment
      t.references  :group
      t.references  :user
      t.timestamps
    end
  end
end
