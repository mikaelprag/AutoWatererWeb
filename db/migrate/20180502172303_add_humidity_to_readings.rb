class AddHumidityToReadings < ActiveRecord::Migration[5.2]
  def change
    add_column :readings, :humidity, :decimal, after: :temp
  end
end
