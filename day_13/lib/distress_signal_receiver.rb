require 'pry'
require 'json'

class DistressSignalReceiver
  attr_reader :distress_signals

  def initialize(txt_file = 'input.txt')
    @distress_signals = []
    parse_distress_signals(txt_file)
  end

  def compare_distress_signals
    distress_signals.filter_map.with_index do |signal, i|
      (i + 1) if correct_order?(signal)
    end
  end

  def correct_order?(signal)
    catch(:order) do
      zipped(signal).each do |sub_signal|
        compare(sub_signal)
      end
    end
  end

  def zipped(signal)
    @signal = signal

    if left.size >= right.size
      left.zip(right)
    else
      right.zip(left).map(&:reverse)
    end
  end

  def compare(signal)
    @signal = signal

    if left.nil?
      throw(:order, true)
    elsif right.nil?
      throw(:order, false)
    elsif left.is_a?(Integer) && right.is_a?(Integer)
      return if left == right

      left < right ? throw(:order, true) : throw(:order, false)
    elsif left.is_a?(Array) && right.is_a?(Array)
      zipped([left, right]).each { compare(_1) }
    elsif left.is_a?(Integer) && right.is_a?(Array)
      zipped([[left], right]).each { compare(_1) }
    elsif left.is_a?(Array) && right.is_a?(Integer)
      zipped([left, [right]]).each { compare(_1) }
    end
  end

  private

  def parse_distress_signals(txt_file)
    signal = []

    File.readlines(txt_file).map do |line|
      next if line == "\n"

      if signal.empty?
        signal << JSON.parse(line)
      else
        signal << JSON.parse(line)
        @distress_signals << signal
        signal = []
      end
    end
  end

  def left
    @signal[0]
  end

  def right
    @signal[1]
  end
end

distress_signal_receiver = DistressSignalReceiver.new
pp distress_signal_receiver.compare_distress_signals.sum
