module Day10
  module Result
    class Ok end

    class Corrupted
      attr_reader :illegal_char

      def initialize(illegal_char)
        @illegal_char = illegal_char
      end

      def eql?(other)
        other == self.class || other.instance_of?(self.class)
      end
    end

    class Incomplete end
  end

  class SyntaxScore
    MATCHING_PAIRS = {
      '[' => ']',
      '<' => '>',
      '(' => ')',
      '{' => '}'
    }.freeze

    ILLEGAL_CHAR_SCORES = {
      ')' => 3,
      ']' => 57,
      '}' => 1197,
      '>' => 25_137
    }.freeze

    def analyse_string(str)
      stack = []

      str.chars.each do |char|
        if is_an_open_bracket?(char)
          stack.push(char)
        else
          last_char = stack.pop
          return Result::Corrupted.new(char) unless match?(last_char, char)
        end
      end

      stack.empty? ? Result::Ok : Result::Incomplete
    end

    def is_an_open_bracket?(char)
      MATCHING_PAIRS.keys.include?(char)
    end

    def match?(char_a, char_b)
      MATCHING_PAIRS[char_a] == char_b
    end

    def score_single_line(string)
      result = analyse_string(string)
      return 0 unless result.instance_of?(Result::Corrupted)

      ILLEGAL_CHAR_SCORES[result.illegal_char]
    end

    def total_syntax_score(input_array)
      input_array.map do |string|
        score_single_line(string)
      end.sum
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  require_relative './utils'
  input_array = read_input_file(10, 'string')
  scorer = Day10::SyntaxScore.new

  part_a_solution = scorer.total_syntax_score(input_array)
  puts "solution for part A: #{part_a_solution}"

  # part_b_solution = smoke_basin.largest_basins_area_product
  # puts "solution for part B: #{part_b_solution}"
end
