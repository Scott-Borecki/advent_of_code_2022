require 'pry'

class TreeHouseLocator
  attr_reader :tree_rows, :tree_columns, :x_max, :y_max

  def initialize(txt_file = 'input.txt')
    @tree_rows = File.readlines(txt_file).map { _1.chomp.chars.map(&:to_i) }
    @tree_columns = tree_rows.transpose
    @x_max = tree_columns.length - 1
    @y_max = tree_rows.length - 1
  end

  def visible_tree_count
    tree_rows.each_with_index.sum do |tree_row, y|
      tree_row.each_with_index.count do |tree_height, x|
        edge_tree?(x, y) || tree_heights_by_direction(x, y).map(&:max).min < tree_height
      end
    end
  end

  def max_scenic_score
    scores = []
    tree_rows.each_with_index do |tree_row, y|
      tree_row.each_with_index.max_by do |tree, x|
        scores << scenic_score(tree, x, y)
      endgit sta
    end
    scores.max
  end

  private

  def edge_tree?(x, y)
    x == 0 || y == 0 || x == x_max || y == y_max
  end

  def scenic_score(tree, x, y)
    return 0 if edge_tree?(x, y)

    tree_heights_by_direction(x, y).map do |tree_heights|
      directional_scenic_score(tree_heights, tree, x, y)
    end.reduce(&:*)
  end

  def directional_scenic_score(tree_heights, view_height, x, y)
    return tree_heights.length if tree_heights.max < view_height

    tree_heights.find_index { |tree_height| tree_height >= view_height } + 1
  end

  def tree_heights_by_direction(x, y)
    [
      tree_rows[y][0..(x-1)].reverse,    # LEFT
      tree_rows[y][(x+1)..-1],           # RIGHT
      tree_columns[x][0..(y-1)].reverse, # TOP
      tree_columns[x][(y+1)..-1]         # BOTTOM
    ]
  end
end

tree_house_locator = TreeHouseLocator.new
puts tree_house_locator.visible_tree_count
puts tree_house_locator.max_scenic_score
