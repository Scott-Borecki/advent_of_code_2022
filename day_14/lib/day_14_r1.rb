require 'pry'

class Position
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def down
    @down ||= Position.new(x, y + 1)
  end

  def down_left
    @down_left ||= Position.new(x - 1, y + 1)
  end

  def down_right
    @down_right ||= Position.new(x + 1, y + 1)
  end
end

class Grid
  attr_reader :grid, :sand_count, :grid_min_x, :grid_max_x, :grid_max_y

  NODE_SEPARATOR = ' -> '.freeze
  COORDINATE_SEPARATOR = ','.freeze
  SAND_START = Position.new(500, 0)

  def initialize(txt_file = File.expand_path('../input.txt', __dir__))
  # def initialize(txt_file = File.expand_path('../spec/fixtures/test_input.txt', __dir__))
    @grid = Hash.new { |h, k| h[k] = {} }
    @grid_min_x = Float::INFINITY
    @grid_max_x = -Float::INFINITY
    @grid_max_y = -Float::INFINITY
    build_grid(txt_file)
    @sand_count = 0
  end

  def sand_at_rest_count
    catch(:sand_count) do
      loop { pour_sand }
    end
  end

  private

  def build_grid(txt_file)
    File.readlines(txt_file).map do |path|
      nodes = path.chomp.split(NODE_SEPARATOR).map { _1.split(COORDINATE_SEPARATOR).map(&:to_i) }
      last_node_index = nodes.size - 1

      nodes.each_with_index do |(x_0, y_0), i|
        next unless i < last_node_index

        x_1 = nodes[i + 1][0]
        y_1 = nodes[i + 1][1]

        if x_0 == x_1
          range(y_0, y_1).each do |y|
            @grid[x_0][y] = '#'
            set_boundaries(x_0, y)
          end
        elsif y_0 == y_1
          range(x_0, x_1).each do |x|
            @grid[x][y_0] = '#'
            set_boundaries(x, y_0)
          end
        end
      end
    end
  end

  def range(initial, final)
    initial < final ? (initial..final) : (final..initial)
  end

  def set_boundaries(x, y)
    @grid_min_x = x if x < grid_min_x
    @grid_max_x = x if x > grid_max_x
    @grid_max_y = y if y > grid_max_y
  end

  def value_at(position)
    grid[position.x][position.y]
  end

  def rest_sand_at(position)
    @sand_count += 1
    @grid[position.x][position.y] = 'o'
  end

  def pour_sand(position = SAND_START)
    if !position_in_bounds?(position)
      throw(:sand_count, sand_count)
    elsif value_at(position.down).nil?
      pour_sand(position.down)
    elsif value_at(position.down_left).nil?
      pour_sand(position.down_left)
    elsif value_at(position.down_right).nil?
      pour_sand(position.down_right)
    else
      rest_sand_at(position)
    end
  end

  def position_in_bounds?(position)
    position.x.between?(grid_min_x, grid_max_x) && position.y <= grid_max_y
  end
end

grid = Grid.new
puts grid.sand_at_rest_count
