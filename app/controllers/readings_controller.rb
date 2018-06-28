class ReadingsController < ApplicationController

  def create
    reading = Reading.new(reading_parameters)
    if reading.save
      render plain: 'ok'
    else
      render plain: 'error', status: 400
    end
  end

  def index
    @readings = Reading.order(id: :desc)
  end


  private

  def reading_parameters
    params.require(:reading).permit(:temp, :light, :humidity, :battery)
  end

end
