class AddPressureToReadings < ActiveRecord::Migration[5.2]
  def change
    add_column :readings, :pressure, :decimal
  end
end
