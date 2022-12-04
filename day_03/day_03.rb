class RucksackReorganizer
  attr_reader :data

  PRIORITY = ([""] + ('a'..'z').to_a + ('A'..'Z').to_a).freeze

  def initialize(txt_file = 'input.txt')
    @data = File.readlines(txt_file).map { _1.chomp.chars }
  end

  def sum_item_type_priorities
    data.sum do |line|
      compartment_size = line.length / 2
      item_type = line.first(compartment_size) & line.last(compartment_size)
      PRIORITY.find_index(item_type.first)
    end
  end

  def sum_badge_type_priorities
    elf_badge_groups.sum do |group|
      group_badge_type = group[0].intersection(*group[1..-1])
      PRIORITY.find_index(group_badge_type.first)
    end
  end

  def elf_badge_groups(group_size = 3)
    groups = []
    group = []
    data.each_with_index do |line, index|
      if (index + 1) % group_size == 0
        groups << (group << line)
        group = []
      else
        group << line
      end
    end
    groups
  end
end

rucksack_reorganizer = RucksackReorganizer.new
puts rucksack_reorganizer.sum_item_type_priorities
puts rucksack_reorganizer.sum_badge_type_priorities
