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

    class Incomplete
      attr_reader :open_brackets

      def initialize(open_brackets)
        @open_brackets = open_brackets
      end

      def eql?(other)
        other == self.class || other.instance_of?(self.class)
      end
    end
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

    INCOMPLETE_CHAR_SCORES = {
      ')' => 1,
      ']' => 2,
      '}' => 3,
      '>' => 4
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

      stack.empty? ? Result::Ok : Result::Incomplete.new(stack)
    end

    def is_an_open_bracket?(char)
      MATCHING_PAIRS.keys.include?(char)
    end

    def match?(char_a, char_b)
      MATCHING_PAIRS[char_a] == char_b
    end

    def score_corrupted_string(result)
      return 0 unless result.instance_of?(Result::Corrupted)

      ILLEGAL_CHAR_SCORES[result.illegal_char]
    end

    def illegal_strings_total_scores(input_array)
      input_array.map do |string|
        result = analyse_string(string)
        score_corrupted_string(result)
      end.sum
    end

    def score_incomplete_string(result)
      return 0 unless result.instance_of?(Result::Incomplete)

      close_brackets_needed = result.open_brackets
                                    .map { |char| MATCHING_PAIRS[char] }
                                    .reverse
      score_incomplete_chars(close_brackets_needed)
    end

    def score_incomplete_chars(chars)
      return 0 if chars.empty?

      current_char = chars.last
      INCOMPLETE_CHAR_SCORES[current_char] + 5 * score_incomplete_chars(chars[0..-2])
    end

    def incomplete_strings_middle_score(input_array)
      all_scores = input_array.map do |string|
        result = analyse_string(string)
        score_incomplete_string(result)
      end

      all_scores.filter!(&:positive?)
                .sort!

      all_scores[all_scores.length / 2]
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  require_relative './utils'
  input_array = read_input_file(10, 'string')
  scorer = Day10::SyntaxScore.new

  part_a_solution = scorer.illegal_strings_total_scores(input_array)
  puts "solution for part A: #{part_a_solution}"

  part_b_solution = scorer.incomplete_strings_middle_score(input_array)
  puts "solution for part B: #{part_b_solution}"
end
