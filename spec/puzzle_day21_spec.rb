require 'puzzle_day21'

describe Day21::DiceGame do
  let(:game) { described_class.new(4, 8) }

  describe '#dice' do
    it 'return 3 numbers of a 100-side deterministic dice' do
      expect(game.dice).to eq [1, 2, 3]
      expect(game.dice).to eq [4, 5, 6]
      expect(game.dice).to eq [7, 8, 9]
    end

    it 'wrap back to 1 after 100' do
      33.times { game.dice }

      expect(game.dice).to eq [100, 1, 2]
      expect(game.dice).to eq [3, 4, 5]
    end

    it 'record the number of dice throw in game' do
      123.times { game.dice }

      expect(game.number_of_dice_throw).to eq 369
    end
  end

  describe '#tick' do
    describe 'a player play their move and get score' do
      it 'first turn' do
        game.tick
        expect(game.player_score(1)).to eq 10
        expect(game.player_position(1)).to eq 10
        expect(game.player_score(2)).to eq 0
        expect(game.player_position(2)).to eq 8
      end

      it 'second turn' do
        2.times { game.tick }

        expect(game.player_score(2)).to eq 3
        expect(game.player_position(2)).to eq 3
      end

      test_cases = [
        { turn: 3, player1_score: 14, player2_score: 3 },
        { turn: 4, player1_score: 14, player2_score: 9 },
        { turn: 5, player1_score: 20, player2_score: 9 },
        { turn: 6, player1_score: 20, player2_score: 16 },
        { turn: 7, player1_score: 26, player2_score: 16 },
        { turn: 8, player1_score: 26, player2_score: 22 }
      ]

      it '3rd to 8th turns' do
        2.times { game.tick }
        test_cases.each do |expected|
          game.tick
          expect(game.player_score(1)).to eq expected[:player1_score]
          expect(game.player_score(2)).to eq expected[:player2_score]
        end
      end
    end
  end

  describe '#play_until_wins' do
    it 'run the game until one of the player reach 1000 score' do
      game.play_until_wins

      expect(game.player_score(1)).to eq 1000
      expect(game.player_position(1)).to eq 10
      expect(game.player_score(2)).to eq 745
      expect(game.number_of_dice_throw).to eq 993
    end
  end

  describe '#move_player' do
    it "move a player's position forward" do
      expect(game.player_position(1)).to eq 4
      game.move_player(1, 4)

      expect(game.player_position(1)).to eq 8
    end
  end

  describe '#add_score_for_player' do
    it 'increase player score by the value of position their pawn is on' do
      expect(game.player_position(1)).to eq 4
      expect(game.player_score(1)).to eq 0

      game.add_score_for_player(1)
      expect(game.player_score(1)).to eq 4
    end
  end

  describe '#part_a_solution' do
    it 'compute the solution for example case correctly' do
      expected = 739_785
      actual = game.part_a_solution

      expect(actual).to eq expected
    end
  end
end

describe Day21::DiracDice do
  let(:game) { described_class.new }

  describe 'tick' do
    expected_results = [
      { player1_score: 0, player2_score: 0, player1_position: 4, player2_position: 8, current_player: 1 },
      { player1_score: 10, player2_score: 0, player1_position: 10, player2_position: 8, current_player: 2 },
      { player1_score: 10, player2_score: 3, player1_position: 10, player2_position: 3, current_player: 1 },
      { player1_score: 14, player2_score: 3, player1_position: 4, player2_position: 3, current_player: 2 },
      { player1_score: 14, player2_score: 9, player1_position: 4, player2_position: 6, current_player: 1 },
      { player1_score: 20, player2_score: 9, player1_position: 6, player2_position: 6, current_player: 2 },
      { player1_score: 20, player2_score: 16, player1_position: 6, player2_position: 7, current_player: 1 },
      { player1_score: 26, player2_score: 16, player1_position: 6, player2_position: 7, current_player: 2 },
      { player1_score: 26, player2_score: 22, player1_position: 6, player2_position: 6, current_player: 1 },
      { player1_score: 30, player2_score: 22, player1_position: 4, player2_position: 6, current_player: 2 },
      { player1_score: 30, player2_score: 25, player1_position: 4, player2_position: 3, current_player: 1 },
      { player1_score: 40, player2_score: 25, player1_position: 10, player2_position: 3, current_player: 2 },
      { player1_score: 40, player2_score: 33, player1_position: 10, player2_position: 8, current_player: 1 },
      { player1_score: 44, player2_score: 33, player1_position: 4, player2_position: 8, current_player: 2 },
      { player1_score: 44, player2_score: 34, player1_position: 4, player2_position: 1, current_player: 1 },
      { player1_score: 50, player2_score: 34, player1_position: 6, player2_position: 1, current_player: 2 },
      { player1_score: 50, player2_score: 36, player1_position: 6, player2_position: 2, current_player: 1 },
      { player1_score: 56, player2_score: 36, player1_position: 6, player2_position: 2, current_player: 2 },
      { player1_score: 56, player2_score: 37, player1_position: 6, player2_position: 1, current_player: 1 },
      { player1_score: 60, player2_score: 37, player1_position: 4, player2_position: 1, current_player: 2 },
      { player1_score: 60, player2_score: 45, player1_position: 4, player2_position: 8, current_player: 1 }
    ]
    it 'take a game state and next dice sum, return a new game state' do
      input = expected_results[0]
      expected = expected_results[1]

      actual = game.tick(input, 1 + 2 + 3)

      expect(actual).to eq expected
    end

    it 'can run the game same as simplified version' do
      dice = (1..100).cycle
      throw_dice = -> { 3.times.map { dice.next }.sum }

      expected_results[0..-2].each_with_index do |game_state, i|
        expected = expected_results[i + 1]
        actual = game.tick(game_state, throw_dice.call)

        expect(actual).to eq expected
      end
    end

    it 'does not mutate the input game state' do
      input = expected_results[0]
      input_clone = input.clone

      game.tick(input, 1 + 2 + 3)

      expect(input).to eq input_clone
    end
  end

  describe 'probability_distribution' do
    it 'returns a hash that describe the probability distribution of outcome rolling 3d3' do
      actual_output = game.probability_distribution

      expect(actual_output.values.sum).to eq 27

      simulate_3d3 = -> { rand(1..3) + rand(1..3) + rand(1..3) }
      simulation_result = Hash.new(0)
      10_000.times do
        sum = simulate_3d3.call
        simulation_result[sum] += 1
      end
      simulation_result.transform_values! { |v| v / 10_000.0 }

      actual_output.each do |dice_sum, instances|
        actual = instances / 27.0
        expected = simulation_result[dice_sum]
        expect(actual).to be_within(0.1).of(expected)
      end
    end
  end

  describe 'hash_game_state' do
    it 'extract the 5 variables of a game state as a unique hash key', long_test: true do
      input = { player1_score: 12, player2_score: 20, player1_position: 5, player2_position: 7,
                current_player: 1 }
      expected = '[12, 20, 5, 7, 1]'

      actual = game.hash_game_state(input)
      expect(actual).to eq expected
    end

    it 'any unique game state have a unique hash' do
      all_possible_states = (0..21).flat_map do |a|
        (0..21).flat_map do |b|
          (1..10).flat_map do |c|
            (1..10).flat_map do |d|
              (1..2).map do |e|
                {
                  player1_score: a, player2_score: b, player1_position: c, player2_position: d,
                  current_player: e
                }
              end
            end
          end
        end
      end
      outputs = all_possible_states.map { |game_state| game.hash_game_state(game_state) }
      expect(outputs.uniq!).to be nil
    end
  end

  describe 'start_new_game' do
    it 'build an initial game state from given initial player positions' do
      player_init_positions = [4, 8]
      expected = { player1_score: 0, player2_score: 0, player1_position: 4, player2_position: 8,
        current_player: 1 }

      actual = game.start_new_game(*player_init_positions)
      expect(actual).to eq expected
    end
  end

  describe 'sum_possible_outcomes_from_state' do
    it 'return the results of parallel universe game branching off from a given state' do
      input_state = { player1_score: 12, player2_score: 20, player1_position: 10, player2_position: 10,
                      current_player: 1 }
      # player1 will win only if got dice total == 9, which happens only in 1/27
      # Any other case (26/27) will lead to next turn, in which player 2 will certainly win in all 27 outcomes
      # so player 2 wins in 26 * 27 universes while player 1 wins in 1
      expected = {
        player1_wins: 1,
        player2_wins: 26 * 27
      }
      actual = game.sum_possible_outcomes_from_state(input_state)

      expect(actual).to eq expected
    end

    it 'compute the example case correctly' do
      input_state = {
        player1_score: 0, player2_score: 0, player1_position: 4, player2_position: 8,
        current_player: 1
      }
      expected = {
        player1_wins: 444_356_092_776_315,
        player2_wins: 341_960_390_180_808
      }

      actual = game.sum_possible_outcomes_from_state(input_state)

      expect(actual).to eq expected
    end
  end
end
