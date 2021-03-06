class ReadingsController < ApplicationController

  def create
    reading = Reading.new(reading_parameters)
    if reading.save
      render plain: 'ok'
    else
      render plain: 'error', status: 400
    end
  end

  def latest
    @station = Station.find(params[:station_id])
    data = {
    }

    if @station.present?
      reading = Reading.where(station: @station).order(id: :desc).first
      data[:temperature] = reading.temp
      data[:humidity] = reading.humidity
    end

    render json: data
  end

  def index

    @ip = `hostname -I`.strip

    grouping = :hour
    time_span = nil

    if params[:span].eql?('day')
      time_span = 1.day.ago..Time.zone.now
    elsif params[:span].eql?('month')
      time_span = 1.month.ago..Time.zone.now
    elsif params[:span].eql?('3months')
      time_span = 3.month.ago..Time.zone.now
      grouping = :day
    elsif params[:span].eql?('6months')
      time_span = 6.month.ago..Time.zone.now
      grouping = :day
    elsif params[:span].eql?('12months')
      time_span = 12.month.ago..Time.zone.now
      grouping = :week
    elsif params[:span].eql?('3years')
      time_span = 3.years.ago..Time.zone.now
      grouping = :week
    else
      time_span = 1.week.ago..Time.zone.now
    end

    @stations = Station.where(id: params[:id])
    @stations = Station.all unless @stations.any?

    @stations.each do |station|

      station.data = Reading.where(created_at: time_span, station: station)

      station.data = if grouping == :week
        station.data.group_by_week(:created_at)
      elsif grouping == :day
        station.data.group_by_day(:created_at)
      elsif grouping == :hour
        station.data.group_by_hour(:created_at)
      else
        raise "No grouping was selected."
      end
    end

    @readings = Reading.where(created_at: time_span).where(station: @stations)
    @notes = Note.where(happend: time_span).order(happend: :asc)

    if @stations.length.eql?(1)
      # TODO Base this on the current day if sun is up / sun is down already.
      @sun = {}
      sun_data = Reading.where(created_at: Time.zone.now.yesterday.all_day).where(station: @stations.first).where('light > ?', Reading::SUN_THRESHOLD)
      @sun[:up] = sun_data.first
      @sun[:down] = sun_data.last
    end

    @chart_notes = Note.where(happend: time_span)

    

  end


  private

  def reading_parameters
    params.require(:reading).permit(:temp, :light, :humidity, :battery)
  end

end
