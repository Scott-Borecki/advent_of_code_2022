require 'json'
require 'pry'
require_relative 'day_17.rb'

RSpec.describe PyroclasticFlow do
  subject(:pyroclastic_flow) { described_class.new(**options) }

  let(:options) { { txt_file: 'test_input.txt' } }

  it { expect(pyroclastic_flow).to be_an_instance_of(PyroclasticFlow) }
  it { expect(pyroclastic_flow.occupied_spaces).to be_a(Hash) }
  it { expect(pyroclastic_flow.occupied_spaces).to be_empty }
  it { expect(pyroclastic_flow.max_height).to eq(0) }

  it 'builds a minus shape' do
    expect(pyroclastic_flow.minus).to contain_exactly([2, 3], [3, 3], [4, 3], [5, 3])
  end

  it 'builds a plus shape' do
    expect(pyroclastic_flow.plus).to contain_exactly([2, 4], [3, 3], [3, 4], [3, 5], [4, 4])
  end

  it 'builds a jay shape' do
    expect(pyroclastic_flow.jay).to contain_exactly([2, 3], [3, 3], [4, 3], [4, 4], [4, 5])
  end

  it 'builds a vertical shape' do
    expect(pyroclastic_flow.vertical).to contain_exactly([2, 3], [2, 4], [2, 5], [2, 6])
  end

  it 'builds a square shape' do
    expect(pyroclastic_flow.square).to contain_exactly([2, 3], [2, 4], [3, 3], [3, 4])
  end

  describe '#build_rock_tower' do
    context 'first rock shape' do
      it 'sets the occupied spaces' do
        pyroclastic_flow.build_rock_tower(1)
        expect(pyroclastic_flow.occupied_spaces.keys).to contain_exactly(
          [2, 0], [3, 0], [4, 0], [5, 0]
        )
      end
    end

    context 'second rock shape' do
      it 'sets the occupied spaces' do
        pyroclastic_flow.build_rock_tower(2)
        expect(pyroclastic_flow.occupied_spaces.keys).to contain_exactly(
          [2, 0], [3, 0], [4, 0], [5, 0],
          [2, 2], [3, 1], [3, 2], [3, 3], [4, 2]
        )
      end
    end

    context 'third rock shape' do
      it 'sets the occupied spaces' do
        pyroclastic_flow.build_rock_tower(3)        
        expect(pyroclastic_flow.occupied_spaces.keys).to contain_exactly(
          [2, 0], [3, 0], [4, 0], [5, 0],
          [2, 2], [3, 1], [3, 2], [3, 3], [4, 2],
          [0, 3], [1, 3], [2, 3], [2, 4], [2, 5]
        )
      end
    end
  end
end
