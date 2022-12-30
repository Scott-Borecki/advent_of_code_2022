require 'json'
require 'pry'
require_relative 'day_16.rb'

RSpec.describe Valve do
  subject(:valve) { described_class.new(name, flowrate, distances) }

  let(:name) { :AA }
  let(:flowrate) { 0 }
  let(:distances) { { BB: 2, DD: 2, II: 2 } }

  it { expect(valve).to be_an_instance_of(Valve) }

  describe '#add_adjacent_valve' do
    let(:adjacent_valve) { described_class.new(:BB, 20, {}) }

    it 'adds the adjacent valve to the collection' do
      valve.add_adjacent_valve(adjacent_valve)
      expect(valve.adjacent_valves).to contain_exactly(adjacent_valve)
    end
  end

  describe '#update_distance' do
    it 'updates the distance when there is a longer path' do
      valve.update_distance(:BB, 1)
      expect(valve.distances[:BB]).to eq(1)
    end

    it 'does not update the distance when there is a shorter path' do
      valve.update_distance(:BB, 3)
      expect(valve.distances[:BB]).to eq(2)
    end
  end
end

RSpec.describe ValveRepository do
  subject(:valve_repository) { described_class.new(txt_file) }

  let(:txt_file) { 'test_input.txt' }

  it { expect(valve_repository).to be_an_instance_of(ValveRepository) }
  it { expect(valve_repository.valves).to all be_an_instance_of(Valve) }
  it { expect(valve_repository.valves.size).to eq(10) }
  it { expect(valve_repository.unopened_valves.map(&:name)).to contain_exactly(:BB, :CC, :DD, :EE, :HH, :JJ) }
  it { expect(valve_repository.find_by_name(:AA).name).to eq(:AA) }

  it 'populates adjacent valves' do
    expect(valve_repository.find_by_name(:AA).adjacent_valves.map(&:name)).to contain_exactly(:BB, :DD, :II)
  end

  it 'collects the distances for each valve' do
    expect(valve_repository.find_by_name(:AA).distances).to eq({ BB: 1, CC: 2, DD: 1, EE: 2, HH: 5, JJ: 2 })
  end
end

RSpec.describe VolcanoEscape do
  subject(:volcano_escape) { described_class.new(txt_file) }

  let(:txt_file) { 'test_input.txt' }

  it { expect(volcano_escape).to be_an_instance_of(VolcanoEscape) }
  it { expect(volcano_escape.valve_repository).to be_an_instance_of(ValveRepository) }
  it { expect(volcano_escape.start_valve.name).to eq(described_class::START_VALVE) }
  it { expect(volcano_escape.max_pressure_released).to eq(0) }

  it 'returns the max pressure released for the given start valve and escape time' do
    volcano_escape.move_or_open_valve
    expect(volcano_escape.max_pressure_released).to eq(1651)
  end
end
