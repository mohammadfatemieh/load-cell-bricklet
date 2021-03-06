#!/usr/bin/env ruby
# -*- ruby encoding: utf-8 -*-

require 'tinkerforge/ip_connection'
require 'tinkerforge/bricklet_load_cell'

include Tinkerforge

HOST = 'localhost'
PORT = 4223
UID = 'XYZ' # Change XYZ to the UID of your Load Cell Bricklet

ipcon = IPConnection.new # Create IP connection
lc = BrickletLoadCell.new UID, ipcon # Create device object

ipcon.connect HOST, PORT # Connect to brickd
# Don't use device before ipcon is connected

# Get threshold callbacks with a debounce time of 1 second (1000ms)
lc.set_debounce_period 1000

# Register weight reached callback
lc.register_callback(BrickletLoadCell::CALLBACK_WEIGHT_REACHED) do |weight|
  puts "Weight: #{weight} g"
end

# Configure threshold for weight "greater than 200 g"
lc.set_weight_callback_threshold '>', 200, 0

puts 'Press key to exit'
$stdin.gets
ipcon.disconnect
