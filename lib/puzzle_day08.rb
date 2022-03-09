require 'set'
module Day08
  SegmentDict = {
    0 => 'abcefg',
    1 => 'cf',
    2 => 'acdeg',
    3 => 'acdfg',
    4 => 'bcdf',
    5 => 'abdfg',
    6 => 'abdefg',
    7 => 'acf',
    8 => 'abcdefg',
    9 => 'abcdfg'
  }

  def self.parse_input_string(string)
    string.split(' | ').map { |substr| substr.split(' ') }
  end

  def self.count_1478_in_one_line(output_signal)
    output_signal.count { |string| [2, 3, 4, 7].include?(string.length) }
  end

  def self.count_1478s_in_all_entries(input_array)
    total_count = 0
    all_output_signals = input_array.map do |input_string|
      _, output_signal = Day08.parse_input_string(input_string)
      output_signal
    end
    all_output_signals.map do |output_signal|
      Day08.count_1478_in_one_line(output_signal)
    end.sum
  end
  
  def self.sum_all_decoded_outputs(input_array)
    input_array.map do |input_string|
      SegmentDisplay.new(input_string).decode_output
    end.sum
  end

  class SegmentDisplay
    def initialize(input_string)
      @ten_digits_patterns, @output_signal = Day08.parse_input_string(input_string)
    end

    def zero
      @zero ||= @ten_digits_patterns.find do |pattern|
        pattern.size == 6 && pattern != six && pattern != nine
      end
    end

    def one
      @one ||= @ten_digits_patterns.find { |pattern| pattern.size == 2 }
    end

    def two
      @two ||= @ten_digits_patterns.find do |pattern|
        pattern.size == 5 && pattern != three && pattern != five
      end
    end

    def three
      @three ||= @ten_digits_patterns.find do |pattern|
        pattern.size == 5 && superset_of?(pattern, one)
      end
    end

    def four
      @four ||= @ten_digits_patterns.find { |pattern| pattern.size == 4 }
    end

    def five
      @five ||= @ten_digits_patterns.find do |pattern|
        pattern.size == 5 && superset_of?(six, pattern)
      end
    end

    def six
      @six ||= @ten_digits_patterns.find do |pattern|
        pattern.size == 6 && !superset_of?(pattern, one)
      end
    end

    def seven
      @seven ||= @ten_digits_patterns.find { |pattern| pattern.size == 3 }
    end

    def eight
      @eight ||= @ten_digits_patterns.find { |pattern| pattern.size == 7 }
    end

    def nine
      @nine ||= @ten_digits_patterns.find do |pattern|
        pattern.size == 6 && superset_of?(pattern, four)
      end
    end

    def superset_of?(pattern_a, pattern_b)
      pattern_b.chars - pattern_a.chars == []
    end

    def match_pattern(pattern_a, pattern_b)
      pattern_a.chars.to_set == pattern_b.chars.to_set
    end

    def to_pattern(digit)
      raise IndexError unless (0..9).cover?(digit)

      @to_pattern ||= [zero, one, two, three, four, five, six, seven, eight, nine]
      @to_pattern[digit]
    end

    def find_matching_digit(signal_pattern)
      (0..9).find do |digit|
        match_pattern(signal_pattern, to_pattern(digit))
      end
    end

    def decode_output
      decoded_digits = @output_signal.map do |signal_pattern|
        find_matching_digit(signal_pattern)
      end

      decoded_digits.join('').to_i
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  require_relative './utils'
  input_array = read_input_file(8, 'string')

  part_a_solution = Day08.count_1478s_in_all_entries(input_array)
  puts "solution for part A: #{part_a_solution}"

  part_b_solution = Day08.sum_all_decoded_outputs(input_array)
  puts "solution for part B: #{part_b_solution}"
end



=begin
my notes on how to decipher this puzzle with pen & paper:

0 -> [a,b,c,  e,f,g]
1 -> [    c,    f  ]
2 -> [a,  c,d,e  ,g]
3 -> [a,  c,d,  f,g]
4 -> [  b,c,d,  f  ]
5 -> [a,b,  d  ,f,g]
6 -> [a,b,  d,e,f,g]
7 -> [a,  c,    f  ]
8 -> [a,b,c,d,e,f,g]
9 -> [a,b,c,d,  f,g]
freq  8 6 8 7 4 9 7


stroke -> number
2 -> [1]
3 -> [7]
4 -> [4]
5 -> [2,3,5]
6 -> [0,6,9]
7 -> [8]

2 stroke -> 1
3 stroke -> 7
7 stroke -> 8
4 stroke -> 4
6 stroke and not subseting 1 -> 6
6 stroke and subseting 4 -> 9
6 stroke and not 6,9 -> 0
5 stroke and is subset of 6 -> 5
5 stroke and is subset of 9 -> 3
5 stroke and not 5,3 -> 2

2 stroke -> seg c or f
3 stroke - 2 stroke -> seg a
4 stroke - 2 stroke -> seg b or d

3 stroke - 2 stroke -> seg a
freq 4 -> seg e
freq 6 -> seg b
freq 9 -> seg f
set(b or d) - freq 6 -> seg d
set(c or f) - freq 9 -> seg c



be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb |
fdgacbe cefdb cefbgd gcbe
a -> e
g -> b
e -> f
d -> a
b -> c
c -> d
f -> g

'agedbcf', 'ebfacdg'
=end

