class CreateSomeStations < ActiveRecord::Migration[5.2]
  def up
    Station.create(name: 'Spijkenisse')
    Station.create(name: 'Degerfors')
  end
end
