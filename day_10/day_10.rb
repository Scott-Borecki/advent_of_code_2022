require 'pry'

class CathodeRayTube
  attr_reader :data, :cycle, :x, :signal_strength, :pixels

  INITIAL_CYCLE = 20
  CYCLE_INTERVAL = 40
  SPRITE_WIDTH = 3
  ADDX_EXECUTION_CYCLES = 2

  def initialize(txt_file = 'input.txt')
    @data = File.readlines(txt_file).map { _1.chomp.split(' ') }
    @x = 1
    @cycle = 0
    @signal_strength = 0
    @pixels = []
  end

  def execute_program
    data.each do |instruction|
      if instruction.first == 'noop'
        execute_cycle
      elsif instruction.first == 'addx'
        ADDX_EXECUTION_CYCLES.times do
          execute_cycle
        end

        @x += instruction.last.to_i
      end
    end
  end

  def execute_cycle
    draw_pixel
    @cycle += 1
    check_signal_strength
  end

  def check_signal_strength
    if (cycle - INITIAL_CYCLE) % CYCLE_INTERVAL == 0
      @signal_strength += cycle * x
    end
  end

  def draw_pixel
    if (x - 1 <= cycle % CYCLE_INTERVAL) && (cycle % CYCLE_INTERVAL <= x + 1)
      @pixels << '#'
    else
      @pixels << '.'
    end
  end

  def crt_image_output
    pixels.each_slice(CYCLE_INTERVAL) do |row|
      puts row.join
    end
  end
end

cathode_ray_tube = CathodeRayTube.new
cathode_ray_tube.execute_program

puts cathode_ray_tube.signal_strength
puts cathode_ray_tube.crt_image_output
