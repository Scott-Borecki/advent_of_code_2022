require_relative 'spec_helper'

RSpec.describe Position do
  subject(:position) { described_class.new(x, y) }

  let(:x) { 500 }
  let(:y) { 0 }

  it 'exists' do
    expect(position).to be_an_instance_of(Position)
  end

  it 'has readable attributes' do
    expect(position.x).to eq(x)
    expect(position.y).to eq(y)
  end

  it 'has a down position' do
    expect(position.down).to be_an_instance_of(Position)
    expect(position.down.x).to eq(x)
    expect(position.down.y).to eq(y + 1)
  end

  it 'has a down right position' do
    expect(position.down_right).to be_an_instance_of(Position)
    expect(position.down_right.x).to eq(x + 1)
    expect(position.down_right.y).to eq(y + 1)
  end

  it 'has a down left position' do
    expect(position.down_left).to be_an_instance_of(Position)
    expect(position.down_left.x).to eq(x - 1)
    expect(position.down_left.y).to eq(y + 1)
  end

  describe '.build_segment' do
    subject(:segment) { Position.build_segment(start_position, end_position) }

    context 'with a horizontal segment' do
      let(:start_position) { Position.new(502, 9) }
      let(:end_position) { Position.new(494, 9) }

      let(:expected_segment_x) do
        [
          start_position,
          Position.new(501, 9),
          Position.new(500, 9),
          Position.new(499, 9),
          Position.new(498, 9),
          Position.new(497, 9),
          Position.new(496, 9),
          Position.new(495, 9),
          end_position
        ]
      end

      it 'builds a segment' do
        expect(segment).to eq(expected_segment)
      end
    end
  end
end
