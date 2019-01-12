class CreateIndexOnCreatedAtReadings < ActiveRecord::Migration[5.2]
  def change
    add_index :readings, :created_at
  end
end
