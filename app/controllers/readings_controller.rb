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

    @readings = Reading.where(created_at: time_span)
    @notes = Note.where(happend: time_span).order(happend: :asc)

    # TODO Base this on the current day if sun is up / sun is down already.
    @sun = {}
    sun_data = Reading.where(created_at: Time.zone.now.yesterday.all_day).where('light > ?', Reading::SUN_THRESHOLD)
    @sun[:up] = sun_data.first
    @sun[:down] = sun_data.last

    @chart_notes = Note.where(happend: time_span)

    @grouped = if grouping == :week
      @readings.group_by_week(:created_at)
    elsif grouping == :day
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
