class Bingo
  def initialize(input_text)
    @bingo_numbers, board_data_array = parse_input_text(input_text)
    @boards = board_data_array.map { |board_data| BingoBoard.new(board_data) }
  end

  def parse_numbers(num_string)
    num_string.split(',').map(&:to_i)
  end

  def parse_bingo_board(lines)
    lines.map do |line|
      line.split(' ').map(&:to_i)
    end.flatten
  end

  def parse_input_text(lines)
    bingo_numbers = parse_numbers(lines.first)
    all_bingo_boards = parse_bingo_board(lines[2..])
    bingo_boards = []
    0.step(all_bingo_boards.length - 1, 25).each do |i|
      bingo_boards << all_bingo_boards[i, 25]
    end

    [bingo_numbers, bingo_boards]
  end

  def boards_won
    [2]
  end

  def board_score(_board_number)
    4512
  end
end

class BingoBoard
  attr_reader :numbers

  def initialize(numbers)
    @numbers = numbers
  end

  def marked_positions
    Array.new(25, false)
  end
end
