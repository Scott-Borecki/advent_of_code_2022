require 'pry'

class Rope
  attr_accessor :knots, :movements

  DEFAULT_KNOTS = 2

  def initialize(options = {})
    @movements = File.readlines(options[:txt_file] || 'input.txt').map { _1.chomp.split(' ') }
    @knots = []
    add_knots(options[:knots] || DEFAULT_KNOTS)
  end

  def add_knots(num_knots)
    head = nil
    num_knots.times do
      @knots << Knot.new(head)
      head = @knots.last
    end
  end

  def get_tail_history_count
    movements.each do |movement|
      movement[1].to_i.times do
        move(movement[0])
      end
    end
    knots.last.history.length
  end

  def move(direction)
    knots.each do |knot|
      knot.move(direction)
    end
  end
end

class Knot
  attr_reader :head, :history, :x, :y

  def initialize(head = nil, tail = nil)
    @head = head
    @tail = tail
    @x = 0
    @y = 0
    @history = [[x, y]]
  end

  def coordinates
    [x, y]
  end

  def relative_head_coordinates
    head.coordinates.zip(coordinates).map { |coordinate| coordinate.inject(:-) }
  end

  def move(direction)
    head.nil? ? move_head(direction) : move_tail
    update_history
  end

  def move_head(direction)
    if direction == 'U'
      @y += 1
    elsif direction == 'D'
      @y -= 1
    elsif direction == 'L'
      @x -= 1
    elsif direction == 'R'
      @x += 1
    end
  end

  def move_tail
    return unless relative_head_coordinates.any? { |coordinate| coordinate.abs > 1 }

    if relative_head_coordinates.all? { |coordinate| coordinate.abs.positive? }
      @x += relative_head_coordinates[0] / relative_head_coordinates[0].abs
      @y += relative_head_coordinates[1] / relative_head_coordinates[1].abs
    else
      @x += relative_head_coordinates[0] / 2
      @y += relative_head_coordinates[1] / 2
    end
  end

  def update_history
    @history << coordinates unless history.include?(coordinates)
  end
end

rope = Rope.new
puts rope.get_tail_history_count

rope = Rope.new(knots: 10)
puts rope.get_tail_history_count
