class AddBatteryToReadings < ActiveRecord::Migration[5.2]
  def change
    add_column :readings, :battery, :integer
  end
end
