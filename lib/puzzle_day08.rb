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

  class SegmentDisplay

  end
end

if __FILE__ == $PROGRAM_NAME
  require_relative './utils'
  input_array = read_input_file(8, 'string')

  part_a_solution = Day08.count_1478s_in_all_entries(input_array)
  puts "solution for part A: #{part_a_solution}"

  # part_b_solution = predict_fish_counts(input_string, 256)
  # puts "solution for part B: #{part_b_solution}"
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

