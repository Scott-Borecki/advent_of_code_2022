class MonkeyFactory
  attr_reader :data, :monkeys

  ROUNDS = 20

  def initialize(txt_file = 'input.txt')
    @data = File.readlines(txt_file).map(&:chomp)
    @monkeys = []
  end

  def build_monkeys
    monkey = {}
    data.each do |line|
      if line.start_with?('Monkey ')
        monkey[:id] = line[/Monkey (\d*):/, 1].to_i
      elsif line.start_with?('  Starting items: ')
        monkey[:items] = line[/Starting items: (.*)$/, 1].split(',').map(&:to_i)
      elsif line.start_with?('  Operation: new = old ')
        monkey[:worry_level_operand] = line[/= old (\D*) /, 1]
        worry_level_value = line[/= old \D* (.*)$/, 1]
        monkey[:worry_level_value] = worry_level_value == 'old' ? 'old' : worry_level_value.to_i
      elsif line.start_with?('  Test: divisible by ')
        monkey[:test_divisible_value] = line[/Test: divisible by (\d*)$/, 1].to_i
      elsif line.start_with?('    If true')
        monkey[:true_monkey] = line[/monkey (\d*)$/, 1].to_i
      elsif line.start_with?('    If false')
        monkey[:false_monkey] = line[/monkey (\d*)$/, 1].to_i

        @monkeys << Monkey.new(**monkey)
        monkey = {}
      end
    end
  end

  def monkey_around(number_of_rounds = ROUNDS)
    number_of_rounds.times do
      monkeys.each do |monkey|
        items_to_throw = monkey.inspect_items
        throw_items(items_to_throw)
      end
    end
  end

  def throw_items(items)
    items.each do |(monkey_id, item)|
      monkey = monkeys.find { _1.id == monkey_id }
      monkey.catch_item(item)
    end
  end

  def monkey_business(number_of_monkeys = 2)
    monkeys.map(&:items_inspected).sort.last(number_of_monkeys).reduce(&:*)
  end
end

class Monkey
  attr_reader :id, :items, :items_inspected, :worry_level_operand, :worry_level_value, :test_divisible_value, :true_monkey, :false_monkey

  def initialize(options)
    @id = options[:id]
    @items = options[:items]
    @worry_level_operand = options[:worry_level_operand]
    @worry_level_value = options[:worry_level_value]
    @test_divisible_value = options[:test_divisible_value]
    @true_monkey = options[:true_monkey]
    @false_monkey = options[:false_monkey]
    @items_inspected = 0
  end

  def inspect_items
    throw_items = []

    items.each do |item|
      throw_items << inspect_item(item)
    end

    @items = []

    throw_items
  end

  def inspect_item(item)
    @items_inspected += 1

    # update_worry_level
    value = worry_level_value == 'old' ? item : worry_level_value
    worry_level = if worry_level_operand == '*'
                    item * value
                  elsif worry_level_operand == '+'
                    item + value
                  end

    # divide worry level by 3
    worry_level = worry_level / 3

    # throw_item
    if worry_level % test_divisible_value == 0
      [true_monkey, worry_level]
    else
      [false_monkey, worry_level]
    end
  end

  def catch_item(item)
    @items << item
  end
end

monkey_factory = MonkeyFactory.new
monkey_factory.build_monkeys
monkey_factory.monkey_around
puts monkey_factory.monkey_business
