require 'pry'

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

    def output_game_state
      {
        player1_score: player_score(1),
        player2_score: player_score(2),
        player1_position: player_position(1),
        player2_position: player_position(2),
        current_player: @current_player + 1
      }
    end
  end

  class DiracDice < DiceGame
    def initialize
      @cache = {}
    end

    def start_new_game(player1_position, player2_position)
      { current_player: 1,
        player1_position: player1_position,
        player1_score: 0,
        player2_position: player2_position,
        player2_score: 0 }
    end

    def tick(game_state, dice_sum)
      new_state = game_state.clone
      current_player = game_state[:current_player]
      new_position = game_state["player#{current_player}_position".to_sym] + dice_sum
      new_position = (new_position % 10).zero? ? 10 : new_position % 10
      new_score = game_state["player#{current_player}_score".to_sym] + new_position

      new_state[:current_player] = 3 - current_player
      new_state["player#{current_player}_position".to_sym] = new_position
      new_state["player#{current_player}_score".to_sym] = new_score
      new_state
    end

    def probability_distribution
      return @probability_distribution if @probability_distribution

      permutation_3by3 = (1..3).to_a.repeated_permutation(3).to_a
      result = permutation_3by3.reduce(Hash.new(0)) do |hash, dices|
        hash[dices.sum] += 1
        hash
      end
      @probability_distribution = result
    end

    def get_winner(game_state)
      winning_score = 21

      if game_state[:player1_score] >= winning_score
        :player1_wins
      elsif game_state[:player2_score] >= winning_score
        :player2_wins
      end
    end

    def hash_game_state(game_state)
      [
        game_state[:player1_score],
        game_state[:player2_score],
        game_state[:player1_position],
        game_state[:player2_position],
        game_state[:current_player]
      ].to_s.freeze
    end

    def sum_possible_outcomes_from_state(game_state)
      hash_key = hash_game_state(game_state)
      return @cache[hash_key] if @cache.has_key?(hash_key)

      result = {
        player1_wins: 0,
        player2_wins: 0
      }

      probability_distribution.each do |dice_sum, weight|
        next_state = tick(game_state, dice_sum)
        winner = get_winner(next_state)
        if winner
          result[winner] += weight
        else
          recur_results = sum_possible_outcomes_from_state(next_state)
          result.merge!(recur_results) { |_, a, b| a + weight * b }
        end
      end

      @cache[hash_key] = result.clone
      result
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

  dirac_dice = Day21::DiracDice.new
  init_state = dirac_dice.start_new_game(*player_init_positions)
  part_b_solution = dirac_dice.sum_possible_outcomes_from_state(init_state)
  puts "solution for part B: #{part_b_solution}"

end
