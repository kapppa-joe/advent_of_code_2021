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
  let(:game) { described_class.new(4, 8) }

  describe 'tick' do
    expected_results = [
      { player1_score: 0, player2_score: 0, player1_position: 4, player2_position: 8, current_player: 1 },
      { player1_score: 10, player2_score: 0, player1_position: 10, player2_position: 8, current_player: 0 },
      { player1_score: 10, player2_score: 3, player1_position: 10, player2_position: 3, current_player: 1 },
      { player1_score: 14, player2_score: 3, player1_position: 4, player2_position: 3, current_player: 0 },
      { player1_score: 14, player2_score: 9, player1_position: 4, player2_position: 6, current_player: 1 },
      { player1_score: 20, player2_score: 9, player1_position: 6, player2_position: 6, current_player: 0 },
      { player1_score: 20, player2_score: 16, player1_position: 6, player2_position: 7, current_player: 1 },
      { player1_score: 26, player2_score: 16, player1_position: 6, player2_position: 7, current_player: 0 },
      { player1_score: 26, player2_score: 22, player1_position: 6, player2_position: 6, current_player: 1 },
      { player1_score: 30, player2_score: 22, player1_position: 4, player2_position: 6, current_player: 0 },
      { player1_score: 30, player2_score: 25, player1_position: 4, player2_position: 3, current_player: 1 },
      { player1_score: 40, player2_score: 25, player1_position: 10, player2_position: 3, current_player: 0 },
      { player1_score: 40, player2_score: 33, player1_position: 10, player2_position: 8, current_player: 1 },
      { player1_score: 44, player2_score: 33, player1_position: 4, player2_position: 8, current_player: 0 },
      { player1_score: 44, player2_score: 34, player1_position: 4, player2_position: 1, current_player: 1 },
      { player1_score: 50, player2_score: 34, player1_position: 6, player2_position: 1, current_player: 0 },
      { player1_score: 50, player2_score: 36, player1_position: 6, player2_position: 2, current_player: 1 },
      { player1_score: 56, player2_score: 36, player1_position: 6, player2_position: 2, current_player: 0 },
      { player1_score: 56, player2_score: 37, player1_position: 6, player2_position: 1, current_player: 1 },
      { player1_score: 60, player2_score: 37, player1_position: 4, player2_position: 1, current_player: 0 },
      { player1_score: 60, player2_score: 45, player1_position: 4, player2_position: 8, current_player: 1 }
    ]
    it 'take a game state and next dice sum, return a new game state' do
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
end
