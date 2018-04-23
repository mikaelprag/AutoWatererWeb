class CreateReadings < ActiveRecord::Migration[5.2]
  def change
    create_table :readings do |t|
      t.decimal :temp
      t.integer :light
      t.datetime :happend

      t.timestamps
    end
  end
end
