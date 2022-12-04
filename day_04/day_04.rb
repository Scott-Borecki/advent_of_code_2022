class CampCleanup
  attr_reader :data

  DEFAULT_RANGE = [*1..99].freeze

  def initialize(txt_file = 'input.txt')
    @data = File.readlines(txt_file).map do |line|
              line.chomp.split(/-|, |,/).map(&:to_i).each_slice(2).to_a.map { (_1[0].._1[1]).to_a }
            end
  end

  def count_fully_overlapping_assignments
    data.count do |assignments|
      assignments.any? { |assignment| DEFAULT_RANGE.intersection(*assignments).size == assignment.size }
    end
  end

  def count_overlapping_assignments
    data.count { |assignments| DEFAULT_RANGE.intersection(*assignments).size > 0 }
  end
end

camp_cleanup = CampCleanup.new
puts camp_cleanup.count_fully_overlapping_assignments
puts camp_cleanup.count_overlapping_assignments
