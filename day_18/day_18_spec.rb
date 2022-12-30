require 'json'
require 'pry'
require_relative 'day_18.rb'

RSpec.describe Cube do
  subject(:cube) { described_class.new(coord) }

  let(:coord) { [1, 2, 3] }

  it { expect(cube).to be_an_instance_of(Cube) }
  it { expect(cube.coord).to eq(coord) }
  it { expect(cube.exposed_sides).to contain_exactly(*%i[top bottom right left front back]) }

  it 'covers a side' do
    cube.cover_side(:top)
    expect(cube.exposed_sides).not_to include(:top)
  end

  it 'calculates the exposed surface area' do
    expect(cube.exposed_surface_area).to eq(6)
    cube.cover_side(:top)
    expect(cube.exposed_surface_area).to eq(5)
  end
end

RSpec.describe BoilingBoulders do
  subject(:boiling_boulders) { described_class.new(**options) }

  let(:options) { { coords: [[1,1,1], [2,1,1]] } }

  it { expect(boiling_boulders).to be_an_instance_of(BoilingBoulders) }
  it { expect(boiling_boulders.coords).to eq(options[:coords]) }
  it { expect(boiling_boulders.cubes.size).to eq(2) }
  it { expect(boiling_boulders.total_exposed_surface_area).to eq(10) }

  context 'with the larger test input data' do
    let(:options) { { txt_file: File.expand_path('../day_18/test_input.txt', __dir__) } }

    it { expect(boiling_boulders.total_exposed_surface_area).to eq(64) }
  end

  context 'with another larger test input data' do
    let(:options) { { txt_file: File.expand_path('../day_18/test_input2.txt', __dir__) } }

    it { expect(boiling_boulders.total_exposed_surface_area).to eq(108) }
  end
end
