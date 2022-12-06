class SupplyStacker
  attr_reader :data
  attr_accessor :stack_hash

  def initialize(txt_file = 'input.txt')
    @data = File.readlines(txt_file).map(&:chomp)
    @stack_hash = Hash.new([])
  end

  # HACKY HACKERSON
  def stacks
    stack_lines = []

    data.each do |line|
      stack_lines << line.chars
      break if line.start_with?(' 1')
    end

    max_size = stack_lines.max_by(&:size).size
    transposed_stacks = stack_lines.map do |array|
      missing_elements = max_size - array.size
      array + Array.new(missing_elements)
    end.transpose

    transposed_stackz = transposed_stacks.reject do |stack|
      stack.last == ' ' || stack.last == nil
    end

    transposed_stackzz = transposed_stackz.map do |stack|
      stack.delete(' ')
      stack.compact.reverse
    end

    transposed_stackzz.each do |stack|
      stack_hash[stack[0]] = stack[1..-1]
    end
  end

  def top_crates
    rearranged_stacks.map do |(_stack_id, crates)|
      crates.last
    end.join
  end

  def modified_top_crates
    modified_rearranged_stacks.map do |(_stack_id, crates)|
      crates.last
    end.join
  end

  private

  def rearrangement_procedures
    @rearrangement_procedures ||= data.map do |procedure|
      next unless procedure.include?('move')
      procedure.match(/move ([^>]+) from ([^>]+) to ([^>]+)/).captures
    end.compact
  end

  def rearranged_stacks
    rearrangement_procedures.each do |procedure|
      procedure[0].to_i.times do
        stack_hash[procedure[2]] << stack_hash[procedure[1]].pop
      end
    end
    stack_hash
  end

  def modified_rearranged_stacks
    rearrangement_procedures.each do |procedure|
      stack_hash[procedure[2]] << stack_hash[procedure[1]].pop(procedure[0].to_i)
      stack_hash[procedure[2]].flatten!
    end
    stack_hash
  end
end

supply_stacker = SupplyStacker.new
supply_stacker.stacks
puts supply_stacker.top_crates

supply_stacker = SupplyStacker.new
supply_stacker.stacks
puts supply_stacker.modified_top_crates
