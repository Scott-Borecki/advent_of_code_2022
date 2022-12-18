require 'pry'

class HeightMap
  attr_reader :grid, :max_x, :max_y, :start_nodes, :end_node, :completed_paths

  DEFAULT_START_LETTER = 'S'.freeze
  DEFAULT_END_LETTER = 'E'.freeze
  ENDPOINT_ELEVATION_MAP = { DEFAULT_START_LETTER => 0, DEFAULT_END_LETTER => 25 }.freeze
  ELEVATION_MAP = ('a'..'z').each_with_index.map { |letter, i| [letter, i] }.to_h.merge(ENDPOINT_ELEVATION_MAP).freeze
  MAX_ELEVATION_CHANGE = 1.freeze

  def initialize(opts = {})
    txt_file = opts[:txt_file] || 'input.txt'
    start_letter = opts[:start_letter] || DEFAULT_START_LETTER
    end_letter = opts[:end_letter] || DEFAULT_END_LETTER

    @start_nodes = []
    @grid = build_grid(txt_file, start_letter, end_letter)
    @completed_paths = []
  end

  def shortest_path_length
    shortest_path.size - 1
  end

  private

  def build_grid(txt_file, start_letter, end_letter)
    raw_grid = File.readlines(txt_file)
    @max_y = raw_grid.size - 1

    raw_grid.map.with_index do |raw_row, y|
      row = raw_row.chomp.chars
      @max_x ||= row.size - 1

      row.map.with_index do |letter, x|
        z = ELEVATION_MAP[letter]
        node = Node.new(x:, y:, z:, max_x:, max_y:)

        @start_nodes << node if letter == start_letter
        @end_node = node if letter == end_letter

        node
      end
    end
  end

  def shortest_path
    start_nodes.each { |start_node| possible_paths(start_node, end_node, completed_paths) }
    completed_paths.sort_by(&:size).first
  end

  def possible_paths(current_node, destination, completed_paths, current_path = [])
    if current_node == destination
      @completed_paths << current_path.push(current_node)
    else
      return if equal_or_shorter_path_exists?(current_path, current_node)

      current_node.adjacent_node_coords.each do |adjacent_coord|
        adjacent_node = node_by(adjacent_coord)
        next_possible_path = current_path.clone.push(current_node)

        next unless !next_possible_path.include?(adjacent_node) && valid_step?(next_possible_path, adjacent_node)

        possible_paths(adjacent_node, destination, completed_paths, next_possible_path)
      end
    end
  end

  def valid_step?(current_path, current_node)
    return true if current_node.z <= (previous_node = current_path.last).z + MAX_ELEVATION_CHANGE

    previous_node.remove_invalid_coord(current_node.coord)
    false
  end

  def equal_or_shorter_path_exists?(current_path, current_node)
    return true if current_path.size >= current_node.shortest_path_length

    current_node.update_shortest_path_length(current_path.size)
    false
  end

  def node_by(coord)
    grid[coord[1]][coord[0]]
  end
end

class Node
  attr_reader :x, :y, :z, :coord, :adjacent_node_coords, :shortest_path_length

  def initialize(opts = {})
    @x = opts[:x]
    @y = opts[:y]
    @z = opts[:z]
    @coord = [x, y]
    @adjacent_node_coords = orthogonally_adjacent_coords(opts[:max_y], opts[:max_x])
    @shortest_path_length = Float::INFINITY
  end

  def update_shortest_path_length(length)
    @shortest_path_length = length
  end

  def remove_invalid_coord(coord)
    @adjacent_node_coords.delete(coord)
  end

  private

  # Orthogonally adjacent (Left, Up, Right, Down)
  def orthogonally_adjacent_coords(max_x, max_y)
    possible_orth_adj_coords = [[x - 1, y], [x, y + 1], [x + 1, y], [x, y - 1]]
    possible_orth_adj_coords.select do |adj_coord|
      adj_coord[0].between?(0, max_y) && adj_coord[1].between?(0, max_x)
    end
  end
end

height_map_p1 = HeightMap.new
puts height_map_p1.shortest_path_length

height_map_p2 = HeightMap.new(start_letter: 'a')
puts height_map_p2.shortest_path_length
