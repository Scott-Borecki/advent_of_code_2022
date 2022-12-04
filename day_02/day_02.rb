class RockPaperScissorsScorer
  attr_reader :data

  SCORE_MAP = {
    'A X' => 1 + 3, 'A Y' => 2 + 6, 'A Z' => 3 + 0,
    'B X' => 1 + 0, 'B Y' => 2 + 3, 'B Z' => 3 + 6,
    'C X' => 1 + 6, 'C Y' => 2 + 0, 'C Z' => 3 + 3
  }.freeze

  MODIFIED_SCORE_MAP = {
    'A X' => 0 + 3, 'A Y' => 3 + 1, 'A Z' => 6 + 2,
    'B X' => 0 + 1, 'B Y' => 3 + 2, 'B Z' => 6 + 3,
    'C X' => 0 + 2, 'C Y' => 3 + 3, 'C Z' => 6 + 1
  }.freeze

  def initialize(txt_file = 'input.txt')
    @data = File.readlines(txt_file).map(&:chomp)
  end

  def score
    data.sum { |line| SCORE_MAP[line] }
  end

  def modified_score
    data.sum { |line| MODIFIED_SCORE_MAP[line] }
  end
end

rock_paper_scissors_scorer = RockPaperScissorsScorer.new
puts rock_paper_scissors_scorer.score
puts rock_paper_scissors_scorer.modified_score
