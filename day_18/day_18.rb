class Cube
  attr_reader :coord, :exposed_sides

  OPPOSITE_SIDE_MAP = {
    top: :bottom,
    bottom: :top,
    right: :left,
    left: :right,
    front: :back,
    back: :front
  }.freeze

  def initialize(coord)
    @coord = coord
    @exposed_sides = OPPOSITE_SIDE_MAP.keys
  end

  def cover_side(side)
    @exposed_sides.delete(side)
  end

  def exposed_surface_area
    exposed_sides.size
  end

  private

  def top
    @top ||= [coord[0], coord[1], coord[2] + 1]
  end

  def bottom
    @bottom ||= [coord[0], coord[1], coord[2] - 1]
  end

  def right
    @right ||= [coord[0] + 1, coord[1], coord[2]]
  end

  def left
    @left ||= [coord[0] - 1, coord[1], coord[2]]
  end

  def front
    @front ||= [coord[0], coord[1] + 1, coord[2]]
  end

  def back
    @back ||= [coord[0], coord[1] - 1, coord[2]]
  end
end

class BoilingBoulders
  attr_reader :cubes, :coords

  def initialize(options = {})
    @cubes = []
    @coords = options[:coords] || parse_coords(options[:txt_file])
    build_cubes(coords)
    collect_exposed_sides
    collect_exposed_sides
    collect_exposed_sides
  end

  def total_exposed_surface_area
    cubes.sum(&:exposed_surface_area)
  end

  private

  def parse_coords(txt_file)
    txt_file ||= File.expand_path('../day_18/test_input.txt', __dir__)
    File.readlines(txt_file).map { |line| line.chomp.split(',').map(&:to_i) }
  end

  def build_cubes(coords)
    coords.each { |coord| @cubes << Cube.new(coord) }
  end

  def collect_exposed_sides
    cubes.each do |cube|
      cube.exposed_sides.each do |side|
        next if (adj_cube = cubes.find { _1.coord == cube.send(side) }).nil?

        cube.cover_side(side)
        adj_cube.cover_side(Cube::OPPOSITE_SIDE_MAP[side])
      end
    end
  end
end

boiling_boulders = BoilingBoulders.new(coords: [[1,1,1], [2,1,1]])
puts boiling_boulders.total_exposed_surface_area # => 10

boiling_boulders = BoilingBoulders.new(txt_file: File.expand_path('../day_18/test_input.txt', __dir__))
puts boiling_boulders.total_exposed_surface_area # => 64

boiling_boulders = BoilingBoulders.new(txt_file: File.expand_path('../day_18/test_input2.txt', __dir__))
puts boiling_boulders.total_exposed_surface_area # => 108

boiling_boulders = BoilingBoulders.new(txt_file: File.expand_path('../day_18/input.txt', __dir__))
puts boiling_boulders.total_exposed_surface_area # => 4322
