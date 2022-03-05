require 'puzzle_day04'

EXAMPLE_INPUT = <<~INPUT.chomp.split("\n")
  7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

  22 13 17 11  0
   8  2 23  4 24
  21  9 14 16  7
   6 10  3 18  5
   1 12 20 15 19

   3 15  0  2 22
   9 18 13 17  5
  19  8  7 25 23
  20 11 10 24  4
  14 21 16 12  6

  14 21 17 24  4
  10 16 15  9 19
  18  8 23 26 20
  22 11 13  6  5
   2  0 12  3  7
INPUT

describe Bingo do
  let(:bingo) { Bingo.new(EXAMPLE_INPUT) }

  describe '#parse_numbers' do
    it 'return an array of numbers given a string of numbers separated by comma' do
      input = '17,25,31,22,79'
      expected_output = [17, 25, 31, 22, 79]

      expect(bingo.parse_numbers(input)).to eql expected_output
    end
  end

  describe '#parse_bingo_board' do
    it 'return an array of 25 numbers given an array of 5 number strings' do
      input =
        <<~BINGO.chomp.split("\n")
          36 11 70 77 80
          63  3 56 75 28
          89 91 27 33 82
          53 79 52 96 32
          58 14 78 65 38
        BINGO

      expected_output = [
        36, 11, 70, 77, 80,
        63, 3, 56, 75, 28,
        89, 91, 27, 33, 82,
        53, 79, 52, 96, 32,
        58, 14, 78, 65, 38
      ]

      expect(bingo.parse_bingo_board(input)).to eql expected_output
    end
  end

  describe '#parse_input_text' do
    it 'parse the input of this puzzle to an array of number and an nested array of bingo boards' do
      input = EXAMPLE_INPUT
      expected_output = [
        [7, 4, 9, 5, 11, 17, 23, 2, 0, 14, 21, 24, 10, 16, 13, 6, 15, 25, 12, 22, 18, 20, 8, 19, 3, 26, 1],
        [
          [22, 13, 17, 11, 0,
           8,  2, 23,  4, 24,
           21, 9, 14, 16, 7,
           6, 10, 3, 18,  5,
           1, 12, 20, 15, 19],

          [3, 15, 0, 2, 22,
           9, 18, 13, 17, 5,
           19, 8, 7, 25, 23,
           20, 11, 10, 24, 4,
           14, 21, 16, 12, 6],

          [14, 21, 17, 24, 4,
           10, 16, 15, 9, 19,
           18, 8, 23, 26, 20,
           22, 11, 13, 6, 5,
           2, 0, 12, 3, 7]
        ]
      ]

      expect(bingo.parse_input_text(input)).to eql expected_output
    end
  end
end

describe BingoBoard do
  let(:bingo_board) { described_class.new((0..24).to_a) }

  it 'stores a board represented by an array of 25 numbers' do
    expect(bingo_board.numbers).to be_an(Array)
    expect(bingo_board.numbers).to have_attributes(size: 25)
    expect(bingo_board.numbers).to all be_an(Integer)
  end

  describe '#marked_positions' do
    context 'when no number were marked yet' do
      it 'return an array of size 25 filled with false' do
        expect(bingo_board.marked_positions).to eql [false] * 25
      end
    end
  end
end

describe 'Part A acceptance test' do
  it 'solve the example case correctly' do
    bingo = Bingo.new(EXAMPLE_INPUT)
    bingo.tick while bingo.boards_won.empty?

    expect(bingo.boards_won).to eql [2]  # i.e. the third board
    expect(bingo.board_score(2)).to eql 4512
  end
end
