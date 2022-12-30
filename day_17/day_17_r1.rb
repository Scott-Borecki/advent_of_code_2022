require 'pry'

# PART 1 ONLY

class PyroclasticFlow
  attr_reader :jet_pattern, :jet_index, :occupied_spaces, :max_height

  CHAMBER_WIDTH = 7.freeze
  LEFT_OFFSET = 2.freeze
  BOTTOM_OFFSET = 3.freeze
  LAST_ROCK = 2022.freeze

  JET_MAP = {
    "<" => "-",
    ">" => "+"
  }.freeze

  SHAPES = %i[minus plus jay vertical square]

  def initialize(options = {})
    @jet_pattern = options[:jet_pattern] || File.read(options[:txt_file] || 'test_input.txt').chomp
    @jet_index = 0
    @occupied_spaces = Hash.new { |h,k| h[k] = Array.new(CHAMBER_WIDTH, false) }
    @max_height = 0
  end

  def print_rock_tower(shape_coords = [])
    num_rows = (occupied_spaces.keys + shape_coords.map(&:last)).max + 1
    graph = Array.new(num_rows) { Array.new(CHAMBER_WIDTH, '.') }

    occupied_spaces.each do |y, row|
      row.each do |x|
        graph[y][x] = '#' if x
      end
    end

    shape_coords.each do |x, y|
      graph[y][x] = '@'
    end

    graph.reverse.each do |row|
      puts '|' + row.join + '|'
    end

    puts '+' + '-' * CHAMBER_WIDTH + '+'
  end

  def build_rock_tower(last_rock = LAST_ROCK)
    last_rock.times do |shape_index|
      shape_coords = build_shape(shape_index)
      fall(shape_coords)
    end
  end

  def fall(shape_coords)
    pushed_shape_coords = push_shape(shape_coords)
    @jet_index += 1

    dropped_shape_coords = drop_shape(pushed_shape_coords)

    if bottomed_out?(dropped_shape_coords) || spaces_occupied?(dropped_shape_coords)
      place_shape(pushed_shape_coords)
      set_max_height(pushed_shape_coords)
    else
      fall(dropped_shape_coords)
    end
  end

  def spaces_occupied?(shape_coords)
    shape_coords.any? { |x, y| occupied_spaces[y][x] }
  end

  def bottomed_out?(shape_coords)
    shape_coords.any? { |_x, y| y < 0 }
  end

  def place_shape(shape_coords)
    shape_coords.each { |x, y| @occupied_spaces[y][x] = true }

    y_coords = shape_coords.map(&:last).sort

    y_coords.each do |y|
      if occupied_spaces[y].all?
        min_y = occupied_spaces.keys.min
        [min_y..(y - 1)].each do |blocked_y|
          @occupied_spaces.delete(blocked_y)
        end
      end
    end
  end

  def set_max_height(shape_coords)
    shape_max_height = shape_coords.map(&:last).max + 1
    @max_height = shape_max_height if shape_max_height > max_height
  end

  def push_shape(shape_coords)
    pushed_shape_coords = shape_coords.map { |x, y| [x.send(JET_MAP[jet_pattern[jet_index % jet_pattern.size]], 1), y] }

    if pushed_shape_coords.map(&:first).any? { |x| !x.between?(0, (CHAMBER_WIDTH - 1)) } || spaces_occupied?(pushed_shape_coords)
      shape_coords
    else
      pushed_shape_coords
    end
  end

  def drop_shape(shape_coords)
    shape_coords.map { |x, y| [x, y - 1] }
  end

  def build_shape(index)
    send(SHAPES[index % SHAPES.size])
  end

  def minus(start_x = LEFT_OFFSET, start_y = max_height + BOTTOM_OFFSET)
    [
      [start_x, start_y],
      [start_x + 1, start_y],
      [start_x + 2, start_y],
      [start_x + 3, start_y]
    ]
  end

  def plus(start_x = LEFT_OFFSET, start_y = max_height + BOTTOM_OFFSET)
    [
      [start_x + 1, start_y],
      [start_x, start_y + 1],
      [start_x + 1, start_y + 1],
      [start_x + 2, start_y + 1],
      [start_x + 1, start_y + 2]
    ]
  end

  def jay(start_x = LEFT_OFFSET, start_y = max_height + BOTTOM_OFFSET)
    [
      [start_x, start_y],
      [start_x + 1, start_y],
      [start_x + 2, start_y],
      [start_x + 2, start_y + 1],
      [start_x + 2, start_y + 2]
    ]
  end

  def vertical(start_x = LEFT_OFFSET, start_y = max_height + BOTTOM_OFFSET)
    [
      [start_x, start_y],
      [start_x, start_y + 1],
      [start_x, start_y + 2],
      [start_x, start_y + 3]
    ]
  end

  def square(start_x = LEFT_OFFSET, start_y = max_height + BOTTOM_OFFSET)
    [
      [start_x, start_y],
      [start_x, start_y + 1],
      [start_x + 1, start_y],
      [start_x + 1, start_y + 1]
    ]
  end
end

pyroclastic_flow = PyroclasticFlow.new
pyroclastic_flow.build_rock_tower
puts pyroclastic_flow.max_height
