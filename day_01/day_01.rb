class CalorieCounter
  attr_reader :data

  def initialize(txt_file = 'input.txt')
    @data = File.readlines(txt_file).map { _1.chomp.to_i }
  end

  def calories_by_elf
    sum = 0
    data.each_with_object([]) do |line, array|
      next sum += line unless line == 0
      array << sum
      sum = 0
    end
  end

  def max_calories_carried(number_of_elves = 1)
    calories_by_elf.sort.last(number_of_elves).sum
  end
end

calorie_counter = CalorieCounter.new
puts calorie_counter.max_calories_carried
puts calorie_counter.max_calories_carried(3)
