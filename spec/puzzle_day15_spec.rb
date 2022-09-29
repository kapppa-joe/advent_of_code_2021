require 'puzzle_day15'

describe Day15::Chiton do
  day15_example = %w[
    1163751742
    1381373672
    2136511328
    3694931569
    7463417111
    1319128137
    1359912421
    3125421639
    1293138521
    2311944581
  ]

  let(:chiton) { described_class.new(day15_example) }

  describe '#parse_input' do
    it 'parse the input into a nested array of integer' do
      actual_output = chiton.parse_input(day15_example)
      (0..9).each do |y|
        (0..9).each do |x|
          expect(actual_output[y][x]).to eql day15_example[y][x].to_i
        end
      end
    end
  end

  describe '#each_neighbour_of' do
    describe 'return the neighbour coordinates of [0, 0]' do
      it 'returns [1, 0], [0, 1] if given [0, 0]' do
        input = [0, 0]
        expected_output = [[1, 0], [0, 1]]
        expect(chiton.each_neighbour_of(*input).to_a).to eql expected_output
      end
    end

    describe 'handle the edge cases correctly' do
      it 'case of [0, 1]' do
        input = [0, 1]
        expected_output = [[0, 0], [1, 1], [0, 2]]
        expect(chiton.each_neighbour_of(*input).to_a).to match_array(expected_output)
      end

      it 'case of [5, 0]' do
        input = [5, 0]
        expected_output = [[6, 0], [5, 1], [4, 0]]
        expect(chiton.each_neighbour_of(*input).to_a).to match_array(expected_output)
      end

      it 'case of [9, 9] (bottom right corner)' do
        input = [9, 9]
        expected_output = [[8, 9], [9, 8]]
        expect(chiton.each_neighbour_of(*input).to_a).to match_array(expected_output)
      end
    end
  end

  describe '#lowest_risk_path' do
    it 'return 0 if start equals to goal' do
      start = [0, 0]
      goal = [0, 0]
      expected_output = 0

      expect(chiton.lowest_risk_path(start, goal)).to eql expected_output
    end

    describe 'basic case' do
      map = %w[
        01
        23
      ]
      let(:chiton) { described_class.new(map) }

      it 'return the risk value for moving 1 cell correctly' do
        start = [0, 0]
        goal = [1, 0]
        expected_output = 1

        expect(chiton.lowest_risk_path(start, goal)).to eql expected_output
      end

      it 'return the risk value for moving 2 cells correctly' do
        start = [0, 0]
        goal = [1, 1]
        expected_output = 4

        expect(chiton.lowest_risk_path(start, goal)).to eql expected_output
      end
    end

    describe 'acceptance test' do
      it 'solve the example case correctly' do
        map = day15_example
        start = [0, 0]
        goal = [map[0].length - 1, map.length - 1]
        expected_output = 40

        actual_output = described_class.new(map).lowest_risk_path(start, goal)

        expect(actual_output).to eql expected_output
      end
    end
  end
end
