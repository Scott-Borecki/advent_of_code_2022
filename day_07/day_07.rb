require 'pry'

class SpaceChecker
  attr_reader :browsing_steps, :current_directory, :root_directory, :delete_candidates_size, :delete_candidate_sizes

  MAX_DELETE_CANDIDATE_SIZE = 100_000
  REQUIRED_UNUSED_DISK_SPACE = 30_000_000
  TOTAL_DISK_SPACE = 70_000_000
  MAX_USABLE_DISK_SPACE = TOTAL_DISK_SPACE - REQUIRED_UNUSED_DISK_SPACE

  def initialize(txt_file = 'input.txt')
    @browsing_steps = File.readlines(txt_file).map(&:chomp)
    @current_directory = nil
    @root_directory = nil
    @delete_candidates_size = 0
    @delete_candidate_sizes = []
  end

  def self.delete_candidates_size
    space_checker = SpaceChecker.new
    space_checker.browse_filesystem
    space_checker.sum_delete_candidates_size
    space_checker.delete_candidates_size
  end

  def self.delete_candidate_size
    space_checker = SpaceChecker.new
    space_checker.browse_filesystem
    space_checker.delete_candidates
    space_checker.delete_candidate_sizes.sort.first
  end

  def browse_filesystem
    browsing_steps.each do |step|
      next if step == '$ ls'

      if step.start_with?('$ cd')
        directory_name = step[/^\$ cd ([a-z\/\.]*)$/, 1]
        @current_directory = if current_directory.nil?
                               @root_directory = Directory.new(directory_name, nil)
                             elsif directory_name == '..'
                               current_directory.parent_directory
                             else
                               current_directory.find_subdirectory(directory_name)
                             end
      elsif step.start_with?(/^\d/)
        file = FileThing.new(*step.split(' '))
        current_directory.add_file(file)
      elsif step.start_with?('dir ')
        directory = Directory.new(step.split(' ')[1], current_directory)
        current_directory.add_subdirectory(directory)
      end
    end
  end

  def sum_delete_candidates_size(directory = root_directory)
    directory.subdirectories.each do |directory|
      @delete_candidates_size += directory.size unless directory.size > MAX_DELETE_CANDIDATE_SIZE
      sum_delete_candidates_size(directory)
    end
  end

  def delete_candidates(directory = root_directory)
    directory.subdirectories.each do |directory|
      @delete_candidate_sizes << directory.size unless directory.size < (root_directory.size - MAX_USABLE_DISK_SPACE)
      delete_candidates(directory)
    end
  end
end

class Directory
  attr_reader :files, :name, :parent_directory, :subdirectories

  def initialize(name, parent_directory)
    @files = []
    @name = name
    @parent_directory = parent_directory
    @subdirectories = []
  end

  def add_file(file)
    @files << file
  end

  def add_subdirectory(directory)
    @subdirectories << directory
  end

  def find_subdirectory(name)
    subdirectories.find { |subdirectory| name == subdirectory.name }
  end

  def size
    files.sum(&:size) + subdirectories.sum(&:size)
  end
end

class FileThing
  attr_reader :size, :name

  def initialize(size, name)
    @name = name
    @size = size.to_i
  end
end

puts SpaceChecker.delete_candidates_size
puts SpaceChecker.delete_candidate_size
