require_relative 'spec_helper'

RSpec.describe DistressSignalReceiver do
  subject(:distress_signal_receiver) { described_class.new(txt_file) }

  let(:txt_file) { File.expand_path('../spec/fixtures/test_input.txt', __dir__) }

  it 'exists' do
    expect(distress_signal_receiver).to be_an_instance_of(DistressSignalReceiver)
  end

  it 'has readable attributes' do
    expect(distress_signal_receiver.distress_signals).to be_an_instance_of(Array)
    distress_signal_receiver.distress_signals.each do |distress_signal|
      expect(distress_signal.length).to eq(2)
    end
  end

  it 'returns the indexes of the signals in the correct order' do
    expect(distress_signal_receiver.compare_distress_signals).to eq([1, 2, 4, 6])
  end

  let(:signal) { [left, right] }

  context 'when the left side is lower than the right side' do
    let(:left) { [1,1,3,1,1] }
    let(:right) { [1,1,5,1,1] }

    it { expect(distress_signal_receiver.correct_order?(signal)).to be true }
  end

  context 'when the left side is lower than the right side with mixed types' do
    let(:left) { [[1],[2,3,4]] }
    let(:right) { [[1],4] }

    it { expect(distress_signal_receiver.correct_order?(signal)).to be true }
  end

  context' when the right side is smaller' do
    let(:left) { [9] }
    let(:right) { [[8,7,6]] }

    it { expect(distress_signal_receiver.correct_order?(signal)).to be false }
  end

  context 'when the left side runs out of items' do
    let(:left) { [[4,4],4,4] }
    let(:right) { [[4,4],4,4,4] }

    it { expect(distress_signal_receiver.correct_order?(signal)).to be true }
  end

  context 'when the right side runs out of items' do
    let(:left) { [7,7,7,7] }
    let(:right) { [7,7,7] }

    it { expect(distress_signal_receiver.correct_order?(signal)).to be false }
  end

  context 'when the left side runs out of items with an empty array' do
    let(:left) { [] }
    let(:right) { [3] }

    it { expect(distress_signal_receiver.correct_order?(signal)).to be true }
  end

  context 'when the right side is smaller with deeply nested array' do
    let(:left) { [1,[2,[3,[4,[5,6,7]]]],8,9] }
    let(:right) { [1,[2,[3,[4,[5,6,0]]]],8,9] }

    it { expect(distress_signal_receiver.correct_order?(signal)).to be false }
  end

  context 'test case' do
    let(:left) { [1,2,3,[1,2,3],4,1] }
    let(:right) { [1,2,3,[1,2,3],4,0] }

    it { expect(distress_signal_receiver.correct_order?(signal)).to be false }
  end

  context 'test case' do
    let(:left) { [[[1]],1] }
    let(:right) { [[1],2] }

    it { expect(distress_signal_receiver.correct_order?(signal)).to be true }
  end

  context 'test case' do
    let(:left) { [[[1]],2] }
    let(:right) { [[1],1] }

    it { expect(distress_signal_receiver.correct_order?(signal)).to be false }
  end

  context 'test case' do
    let(:left) { [[1],1] }
    let(:right) { [[[1]],2] }

    it { expect(distress_signal_receiver.correct_order?(signal)).to be true }
  end

  context 'test case' do
    let(:left) { [[1],2] }
    let(:right) { [[[1]],1] }

    it { expect(distress_signal_receiver.correct_order?(signal)).to be false }
  end

  context 'test case' do
    let(:left) { [[8,[[7]]]] }
    let(:right) { [[[[8]]]] }

    it { expect(distress_signal_receiver.correct_order?(signal)).to be false }
  end

  context 'test case' do
    let(:left) { [[8,[[7]]]] }
    let(:right) { [[[[8],2]]] }

    it { expect(distress_signal_receiver.correct_order?(signal)).to be true }
  end

  context 'test case' do
    let(:left) { [[1,2],4] }
    let(:right) { [[[3]],5,5] }

    it { expect(distress_signal_receiver.correct_order?(signal)).to be true }
  end

  context 'test case' do
    let(:left) { [[8,[[7,10,10,5],[8,4,9]],3,5],[[[3,9,4],5,[7,5,5]],[[3,2,5],[10],[5,5],0,[8]]],[4,2,[],[[7,5,6,3,0],[4,4,10,7],6,[8,10,9]]],[[4,[],4],10,1]] }
    let(:right) { [[[[8],[3,10],[7,6,3,7,4],1,8]]] }

    it { expect(distress_signal_receiver.correct_order?(signal)).to be true }
  end

  context 'test case' do
    let(:left) { [[0, 0, [[6, 10, 1, 5], [8, 0, 4], 10, [10, 9, 1, 5]]],[[4, [2, 1, 1, 5, 4], [5], []]],[3, 7, 0, [], 10]] }
    let(:right) { [[3], [4, 5], [6, [4, 5, []], 5, 4]] }

    it { expect(distress_signal_receiver.correct_order?(signal)).to be true }
  end
end
