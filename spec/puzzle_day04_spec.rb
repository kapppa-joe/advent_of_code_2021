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

  describe '#tick' do
    it 'mark a bingo number in all boards' do
      bingo.boards.each do |board|
        expect(board).to receive(:mark_number).with(7)
      end
      bingo.tick

      bingo.boards.each do |board|
        expect(board).to receive(:mark_number).with(4)
      end
      bingo.tick
    end
  end

  describe '#boards_won' do
    it 'return an empty array when game start' do
      expect(bingo.boards_won).to eql []
    end

    it 'return the value as expected in example case' do
      12.times do
        bingo.tick
      end
      expect(bingo.boards_won).to eql [2]
    end

    it 'return the won boards correctly in another test case' do
      test_case = EXAMPLE_INPUT.clone
      test_case[0] = '22, 13, 17, 11, 0, 3, 15, 2'
      bingo = described_class.new(test_case)
      8.times { bingo.tick }

      expect(bingo.boards_won).to eql [0, 1]
    end
  end

  describe '#find_part_a_solution' do
    it 'solve the example case correctly' do
      expect(bingo.find_part_a_solution).to eql 4512
    end
  end
end

describe BingoBoard do
  test_data = [
    22, 13, 17, 11, 0,
    8,  2, 23,  4, 24,
    21, 9, 14, 16, 7,
    6, 10, 3, 18,  5,
    1, 12, 20, 15, 19
  ]

  let(:bingo_board) { described_class.new(test_data) }

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

  describe '#mark_number' do
    context 'when this board contain the marked number' do
      it 'set the corresponding cell of marked_positions as true' do
        input = [22, 9, 3]
        input.each do |number|
          bingo_board.mark_number(number)
        end
        marked_positions = bingo_board.marked_positions
        expect(marked_positions[0]).to eql true
        expect(marked_positions[11]).to eql true
        expect(marked_positions[17]).to eql true
      end

      it 'append the given number to @numbers_marked' do
        bingo_board.mark_number(22)
        expect(bingo_board.numbers_marked).to eql [22]

        bingo_board.mark_number(9)
        expect(bingo_board.numbers_marked).to eql [22, 9]
      end
    end

    context 'when this board does not contain the marked number' do
      it 'do not change @numbers_marked' do
        expect(bingo_board.numbers_marked).to eql []
        bingo_board.mark_number(22)
        bingo_board.mark_number(100)
        expect(bingo_board.numbers_marked).to eql [22]
      end
    end
  end

  describe '#has_won?' do
    context 'when no number were marked yet' do
      it 'return false' do
        expect(bingo_board.has_won?).to eql false
      end
    end

    context 'when in any horizontal rows all numbers were marked' do
      it 'return true (test case: 1st row)' do
        numbers = [22, 13, 17, 11, 0]
        numbers.each do |num|
          bingo_board.mark_number(num)
        end

        expect(bingo_board.has_won?).to eql true
      end

      it 'return true (test case: 5th row' do
        bingo_board.numbers[20, 5].each do |num|
          bingo_board.mark_number(num)
        end

        expect(bingo_board.has_won?).to eql true
      end
    end

    context 'when in any vertical columns all numbers were marked' do
      it 'return true (1st column)' do
        numbers = [22, 8, 21, 6, 1]
        numbers.each do |num|
          bingo_board.mark_number(num)
        end

        expect(bingo_board.has_won?).to eql true
      end

      it 'return true (5th column)' do
        numbers = [0, 24, 7, 5, 19]
        numbers.each do |num|
          bingo_board.mark_number(num)
        end

        expect(bingo_board.has_won?).to eql true
      end
    end
  end

  describe '#score' do
    context 'when the board has not won yet' do
      it 'returns 0' do
        expect(bingo_board.score).to eql 0
      end
    end

    context 'when the board has won' do
      it 'return the sum of all unmarked number times the last marked number' do
        numbers = [13, 17, 11, 0, 22] # number in the 1st row
        numbers.each do |num|
          bingo_board.mark_number(num)
        end

        expected_output = bingo_board.numbers[5, 20].sum * 22

        expect(bingo_board.score).to eql expected_output
      end

      it 'return the sum of all unmarked number times the last marked number (another test case)' do
        numbers = [17, 23, 14, 0, 24, 7, 5, 19]
        numbers.each do |num|
          bingo_board.mark_number(num)
        end

        expected_output = (bingo_board.numbers.sum - numbers.sum) * 19

        expect(bingo_board.score).to eql expected_output
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
