require 'pry'

class Valve
  attr_reader :name, :flowrate, :distances, :adjacent_valves

  def initialize(name, flowrate, distances)
    @name = name
    @flowrate = flowrate
    @distances = distances
    @adjacent_valves = []
  end

  def add_adjacent_valve(valve)
    @adjacent_valves << valve
  end

  def update_distance(valve_name, distance)
    return if distances[valve_name].nil? || distances[valve_name] < distance

    @distances[valve_name] = distance
  end

  def remove_open_valve_distances(unopened_valve_names)
    @distances = distances.select { |valve_name, _d| unopened_valve_names.include?(valve_name) }
  end
end

class ValveRepository
  attr_reader :valves, :unopened_valves

  def initialize(txt_file = 'input.txt')
    @valves = []
    build_valves(txt_file)
    @unopened_valves = valves.reject { _1.flowrate == 0 }
    populate_adjacent_valves
    collect_distances
  end

  def find_by_name(name)
    valves.find { _1.name == name }
  end

  def populate_adjacent_valves
    valves.each do |valve|
      valve.distances.keys.each do |adj_valve_name|
        adj_valve = valves.find { _1.name == adj_valve_name }
        valve.add_adjacent_valve(adj_valve)
      end
    end
  end

  def collect_distances
    valves.each do |valve|
      distance_keys = valve.distances.keys
      unopened_valve_names = unopened_valves.map(&:name)

      unopened_valves.each do |unopened_valve|
        next if distance_keys.include?(unopened_valve.name) || valve == unopened_valve

        possible_paths(valve, unopened_valve, current_path = [])
      end

      valve.remove_open_valve_distances(unopened_valve_names)
    end
  end

  def possible_paths(current_valve, destination_valve, current_path = [])
    start_valve = current_path.first

    if current_valve == destination_valve
      distance = current_path.size
      start_valve.update_distance(current_valve.name, distance)
      current_valve.update_distance(start_valve.name, distance)
    else
      return unless current_path.empty? || current_path.size <= start_valve.distances[destination_valve.name]

      current_valve.adjacent_valves.each do |adjacent_valve|
        next unless !(next_possible_path = current_path.clone.push(current_valve)).include?(adjacent_valve)

        possible_paths(adjacent_valve, destination_valve, next_possible_path)
      end
    end
  end

  private

  def build_valves(txt_file)
    File.readlines(txt_file).map do |line|
      /Valve (?<name>-?.+) has flow rate=(?<flowrate>-?\d+); tunnel(s)? lead(s)? to valve(s)? (?<adj_valves>-?.+)$/ =~ line

      distances = adj_valves.split(', ').each_with_object(Hash.new { |h, k| h[k] = Float::INFINITY }) { |v, h| h[v.to_sym] = 1 }

      @valves << Valve.new(name.to_sym, flowrate.to_i, distances)
    end
  end
end

class VolcanoEscape
  attr_reader :valve_repository, :start_valve, :escape_time, :max_pressure_released

  ESCAPE_TIME = 30.freeze
  START_VALVE = :AA.freeze

  def initialize(txt_file = 'input.txt', start_valve = START_VALVE, escape_time = ESCAPE_TIME)
    @valve_repository = ValveRepository.new(txt_file)
    @start_valve = valve_repository.find_by_name(start_valve)
    @escape_time = escape_time
    @max_pressure_released = 0
  end

  def move_or_open_valve(valve = start_valve, time_elapsed = 0, unopened_valves = valve_repository.unopened_valves, pressure_released = 0)
    return if time_elapsed > ESCAPE_TIME

    if time_elapsed == ESCAPE_TIME || unopened_valves.empty?
      return if pressure_released < max_pressure_released

      @max_pressure_released = pressure_released
    else
      next_valves(valve, unopened_valves).each do |next_valve|
        next if (updated_time_elapsed = time_elapsed + valve.distances[next_valve.name] + 1) > ESCAPE_TIME

        remaining_time = ESCAPE_TIME - updated_time_elapsed
        updated_unopened_valves = unopened_valves.clone - [next_valve]
        updated_pressure_released = pressure_released + (remaining_time * next_valve.flowrate)

        move_or_open_valve(next_valve, updated_time_elapsed, updated_unopened_valves, updated_pressure_released)
      end
    end
  end

  def next_valves(valve, unopened_valves)
    unopened_valves.select { valve.distances.keys.include?(_1.name) }
  end
end

volcano_escape = VolcanoEscape.new
volcano_escape.move_or_open_valve
puts volcano_escape.max_pressure_released
