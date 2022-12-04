class CampCleanup
  attr_reader :data

  def initialize(txt_file = 'input.txt')
    @data = File.readlines(txt_file).map do |line|
              assignments = line.chomp.split(',').map { _1.split('-') }.map { _1.map(&:to_i) }
              assignments.map { (_1[0].._1[1]).to_a }
            end
  end

  def count_fully_overlapping_assignments
    data.count do |assignments|
      overlapping_assignments(assignments).size == assignments.first.size ||
        overlapping_assignments(assignments).size == assignments.last.size
    end
  end

  def count_overlapping_assignments
    data.count { |assignments| overlapping_assignments(assignments).size > 0 }
  end

  def overlapping_assignments(assignments)
    assignments.first & assignments.last
  end
end

camp_cleanup = CampCleanup.new
puts camp_cleanup.count_fully_overlapping_assignments
puts camp_cleanup.count_overlapping_assignments
