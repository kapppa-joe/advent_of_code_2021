class Bingo
  attr_reader :boards

  def initialize(input_text)
    @bingo_numbers, board_data_array = parse_input_text(input_text)
    @next_number_index = 0
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
    (0...@boards.length).filter do |board_number|
      @boards[board_number].has_won?
    end
  end

  def tick
    next_number = @bingo_numbers.fetch(@next_number_index)
    @boards.each do |board|
      board.mark_number(next_number)
    end
    @next_number_index += 1
  end

  def board_score(board_number)
    @boards[board_number].score
  end

  def find_part_a_solution
    tick while boards_won.empty?
    board_score(boards_won.first)
  end
end

class BingoBoard
  attr_reader :numbers, :marked_positions, :numbers_marked

  def initialize(numbers)
    @numbers = numbers
    @marked_positions = Array.new(25, false)
    @numbers_marked = []
  end

  def mark_number(num)
    return false unless @numbers.include?(num)

    index = @numbers.index(num)
    @marked_positions[index] = true
    @numbers_marked << num
  end

  def has_won?
    0.step(24, 5) do |start_of_row|
      return true if marked_positions[start_of_row, 5].all?(true)
    end

    (0..4).each do |start_of_column|
      return true if start_of_column.step(24, 5).all? do |cell|
        marked_positions[cell] == true
      end
    end

    false
  end

  def score
    return 0 unless has_won?

    sum_of_unmarked_numbers = @numbers.sum - @numbers_marked.sum
    @numbers_marked.last * sum_of_unmarked_numbers
  end
end




if __FILE__ == $PROGRAM_NAME
  require_relative './utils'
  input_array = read_input_file(4, 'string')

  part_a_solution = Bingo.new(input_array).find_part_a_solution
  puts "solution for part A: #{part_a_solution}"

  # part_b_solution = find_life_support_rating(input_array)
  # puts "solution for part B: #{part_b_solution}"
end
