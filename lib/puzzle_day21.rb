module Day21
  class DiceGame
    attr_reader :number_of_dice_throw

    def initialize(player1, player2)
      @dice = (1..100).cycle
      @number_of_dice_throw = 0

      @current_player = 1
      @player_score = [0, 0]
      @player_position = [player1, player2]
    end

    def player_score(player_num)
      @player_score[player_num - 1]
    end

    def player_position(player_num)
      @player_position[player_num - 1]
    end

    def dice
      @number_of_dice_throw += 3
      3.times.map { @dice.next }
    end

    def tick
      moves_to_take = dice.sum
      move_player(@current_player, moves_to_take)
      add_score_for_player(@current_player)
      switch_player
    end

    def move_player(player_num, moves)
      new_position = @player_position[player_num - 1] + moves
      new_position = (new_position % 10).zero? ? 10 : new_position % 10
      @player_position[player_num - 1] = new_position
    end

    def add_score_for_player(player_num)
      @player_score[player_num - 1] += player_position(player_num)
    end

    def switch_player
      @current_player = 1 - @current_player
    end

    def play_until_wins
      tick until @player_score.max >= 1000
    end

    def part_a_solution
      play_until_wins
      @player_score.min * @number_of_dice_throw
    end

    def game_status
      {
        player1_score: player_score(1),
        player2_score: player_score(2),
        player1_position: player_position(1),
        player2_position: player_position(2),
        current_player: @current_player
      }
    end
  end

  class DiracDice < DiceGame
    # def tick
    #   raise NotImplementedError
    # end

    def tick(game_state, next_dice)
      game_state
    end

    def probability_distribution
      return @probability_distribution if @probability_distribution

      result = (1..3).to_a.repeated_permutation(3).to_a.reduce(Hash.new(0)) do |hash, dices|
        hash[dices.sum] += 1
        hash
      end
      @probability_distribution = result
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  require_relative './utils'
  input = read_input_file(21, 'string')
  player_init_positions = input.map { |line| line[-1].to_i }
  game = Day21::DiceGame.new(*player_init_positions)

  part_a_solution = game.part_a_solution
  puts "solution for part A: #{part_a_solution}"

  game = Day21::DiceGame.new(4, 8)
  puts game.game_status
  20.times.map do
    game.tick
    puts game.game_status
  end

  # enhanced_50_times = 50.times.reduce(image) { |img| trench_map.enhance(img, algorithm) }
  # part_b_solution = trench_map.count_lit_pixels(enhanced_50_times)
  # puts "solution for part B: #{part_b_solution}"

end
