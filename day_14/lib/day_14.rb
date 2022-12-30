require 'pry'

class Grid
  attr_reader :grid, :sand_count

  NODE_SEPARATOR = ' -> '.freeze
  COORDINATE_SEPARATOR = ','.freeze
  SAND_START = [500, 0].freeze

  # def initialize(txt_file = File.expand_path('../input.txt', __dir__))
  def initialize(txt_file = File.expand_path('../spec/fixtures/test_input.txt', __dir__))
    @grid = Hash.new { |h, k| h[k] = [] }
    build_grid(txt_file)
    @sand_count = 0
  end

  def sand_at_rest
    catch(:sand_count) do
      pour_sand
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
          y_range = y_0 < y_1 ? (y_0..y_1) : (y_1..y_0)
          y_range.each { @grid[:"#{x_0.to_s}"][_1] = '#' }
        elsif y_0 == y_1
          x_range = x_0 < x_1 ? (x_0..x_1) : (x_1..x_0)
          x_range.each { @grid[:"#{_1.to_s}"][y_0] = '#' }
        end
      end
    end
  end

  def pour_sand(start = SAND_START)
    column = grid[:"#{start[0].to_s}"][start[1]..-1]

    if column.nil? || column.size == 0 || column.all?(&:nil?)
      p "Endless void in column #{start[0]}: #{grid[:"#{start[0].to_s}"]}"
      throw(:sand_count, sand_count)
    else
      column.each_with_index do |y, i|
        binding.pry if @last_pour == [493, 27]

        current_i = start[1] + i

        if y.nil?
          next
        elsif grid[:"#{(start[0] - 1).to_s}"][current_i].nil?
          @last_pour = [start[0] - 1, current_i]
          p "Pour to left: #{[start[0] - 1, current_i]}"


          pour_sand([start[0] - 1, current_i])
        elsif grid[:"#{(start[0] + 1).to_s}"][current_i].nil?
          @last_pour = [start[0] + 1, current_i]
          p "Pour to right: #{[start[0] + 1, current_i]}"


          pour_sand([start[0] + 1, current_i])
        else
          # binding.pry if [start[0], current_i - 1] == [497, 63]
          p "Rest sand at: #{[start[0], current_i - 1]}"


          @sand_count += 1
          @grid[:"#{start[0].to_s}"][current_i - 1] = 'o'
          pour_sand
        end
      end
    end
  end
end

class Position
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def down
    Position.new(x, y + 1)
  end

  def down_left
    Position.new(x - 1, y + 1)
  end

  def down_right
    Position.new(x + 1, y + 1)
  end
end

grid = Grid.new
binding.pry
puts grid.sand_at_rest
