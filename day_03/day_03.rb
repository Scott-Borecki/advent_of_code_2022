class RucksackReorganizer
  attr_reader :data

  COMPARTMENTS_PER_RUCKSACK = 2.freeze
  GROUP_SIZE = 3.freeze
  PRIORITY = ([""] + [*'a'..'z'] + [*'A'..'Z']).freeze

  def initialize(txt_file = 'input.txt')
    @data = File.readlines(txt_file).map { _1.chomp.chars }
  end

  def sum_item_type_priorities
    data.sum do |line|
      compartments = line.each_slice(line.length / COMPARTMENTS_PER_RUCKSACK).to_a
      item_priority(*compartments)
    end
  end

  def sum_badge_type_priorities
    data.each_slice(GROUP_SIZE).to_a.sum { |group| item_priority(*group) }
  end

  private

  def item_priority(*collection)
    item_type = PRIORITY.intersection(*collection)
    PRIORITY.find_index(*item_type)
  end
end

rucksack_reorganizer = RucksackReorganizer.new
puts rucksack_reorganizer.sum_item_type_priorities
puts rucksack_reorganizer.sum_badge_type_priorities
