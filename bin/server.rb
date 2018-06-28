#!/usr/bin/env ruby
require 'active_record'
require 'pg' # postgresql
require 'serialport'
require 'time'

device = ''

ARGV.each do |a|
  device = "/dev/#{a}"
end

if device.blank?
  puts "You must enter a device!"
  exit(1)
end

if !File.exists?(device)
  puts "This serial port does not exist!"
  exit(1)
end

sp = SerialPort.new(device, 9600, 8, 1, SerialPort::NONE)

ActiveRecord::Base.establish_connection(
  adapter: "postgresql",
  encoding: "unicode",
  database: "AutoWatererWeb_development",
  username: "miccet",
  password: "welcome"
)

class Reading < ActiveRecord::Base
end

input = ""

# AT-09:
while true do
  while (i = sp.getc) do
    input += i unless i.blank?
    if i.blank?
      sp.getc # 2 blank chars, read one more not to trigger second read.
      puts "#{DateTime.now.strftime('%Y-%m-%d %H:%M:%S')} - #{input}"
      cleaned = input.delete('T:').delete('H:').delete('L:').delete('B:')
      data = cleaned.split('|')
      Reading.create(temp: data[0], humidity: data[1], light: data[2], battery: data[3])
      input = ""
    end
  end
end


# HC-05:
# while true do
#   while (i = sp.gets) do
#     puts "#{DateTime.now.strftime('%Y-%m-%d %H:%M:%S')} - #{i}"
#     cleaned = i.delete('T:').delete('H:').delete('L:')
#     data = cleaned.split('|')
#     Reading.create(temp: data[0], humidity: data[1], light: data[2])
#   end
# end
