class TuningTrouble
  attr_reader :data

  PACKET_MARKER_SIZE = 4.freeze
  MESSAGE_MARKER_SIZE = 14.freeze

  def initialize(txt_file = 'input.txt')
    @data = File.read(txt_file).chomp.chars
  end

  def num_characters_processed(marker_size)
    data.each_with_index do |char, index|
      marker = data[index..(index + marker_size - 1)]
      break index + marker_size if (marker & marker).length == marker_size
    end
  end
end

tuning_trouble = TuningTrouble.new
puts tuning_trouble.num_characters_processed(TuningTrouble::PACKET_MARKER_SIZE)
puts tuning_trouble.num_characters_processed(TuningTrouble::MESSAGE_MARKER_SIZE)
