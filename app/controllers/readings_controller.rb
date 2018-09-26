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

    grouping = :hour

    if params[:span].eql?('day')
      @readings = Reading.where(created_at: 1.day.ago..Time.zone.now)
    elsif params[:span].eql?('month')
      @readings = Reading.where(created_at: 1.month.ago..Time.zone.now)
    elsif params[:span].eql?('3months')
      @readings = Reading.where(created_at: 3.month.ago..Time.zone.now)
      grouping = :day
    elsif params[:span].eql?('6months')
      @readings = Reading.where(created_at: 6.month.ago..Time.zone.now)
      grouping = :day
    else
      @readings = Reading.where(created_at: 1.week.ago..Time.zone.now)
    end

    @grouped = if grouping == :day
      @readings.group_by_day(:created_at)
    elsif grouping == :hour
      @readings.group_by_hour(:created_at)
    else
      raise "No grouping was selected."
    end

  end


  private

  def reading_parameters
    params.require(:reading).permit(:temp, :light, :humidity, :battery)
  end

end
