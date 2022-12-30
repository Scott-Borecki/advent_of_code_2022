require 'pry'

class BeaconZone
  attr_reader :sensors, :beacon_locations

  def initialize(txt_file = 'input.txt')
    @sensors = []
    @beacon_locations = []
    populate_sensors(txt_file)
  end

  def empty_positions_by_row(row = 10)
    sensors.flat_map do |sensor|
      sensor.empty_positions_by_row(row)
    end.uniq - beacon_locations
  end

  private

  def populate_sensors(txt_file)
    File.readlines(txt_file).map do |line|
      /Sensor at x=(?<x>-?\d+), y=(?<y>-?\d+): closest beacon is at x=(?<cbx>-?\d+), y=(?<cby>-?\d+)/ =~ line
      @sensors << Sensor.new(x.to_i, y.to_i, cbx.to_i, cby.to_i)
      @beacon_locations << [cbx.to_i, cby.to_i]
    end
  end
end

class Sensor
  attr_reader :x, :y, :distance, :min_y, :max_y

  def initialize(x, y, cbx, cby)
    @x = x
    @y = y
    @cbx = cbx
    @cby = cby
    @distance = (cbx - x).abs + (cby - y).abs
    @min_y = y - distance
    @max_y = y + distance
  end

  def empty_positions_by_row(row)
    return [] if !row.between?(min_y, max_y)

    x_deviation = distance - (row - y).abs
    ((x - x_deviation)..(x + x_deviation)).map { [_1, row] }
  end
end

beacon_zone = BeaconZone.new
puts beacon_zone.empty_positions_by_row(2_000_000).count
