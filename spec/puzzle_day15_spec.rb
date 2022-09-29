require 'puzzle_day15'
require 'utils'

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
        expected_output = 40

        actual_output = described_class.new(map).lowest_risk_path(start)

        expect(actual_output).to eql expected_output
      end
    end

    describe 'acceptance test' do
      it 'compute the example of part B correctly' do
        input = day15_example
        expected_output = 315

        expanded_map = Day15::MapExpand.new.expand(input)
        start = [0, 0]
        actual_output = described_class.new(expanded_map).lowest_risk_path(start)

        expect(actual_output).to eql expected_output
      end
    end
  end
end

describe Day15::MapExpand do
  small_expanded_map_example =
    %w[
      89123
      91234
      12345
      23456
      34567
    ]

  let(:map_expand) { described_class.new }

  describe '::rotate_num' do
    test_cases = {
      [1, 1] => 2,
      [2, 1] => 3,
      [9, 1] => 1,
      [8, 2] => 1,
      [5, 4] => 9,
      [5, 5] => 1,
      [7, 5] => 3
    }

    test_cases.each do |input_values, expected_output|
      it "rotate num: #{input_values} gives #{expected_output}" do
        expect(map_expand.rotate_num(*input_values)).to be(expected_output)
      end
    end
  end

  describe '::expand_to_x' do
    it 'expand an int map across x axis 5 times' do
      input = %w[
        12
        67
      ]
      expected = %w[
        1223344556
        6778899112
      ]
      actual = map_expand.expand_to_x(input)
      expect(actual).to eql expected
    end
  end

  describe '::expand_to_y' do
    it 'expand an int map across y axis 5 times' do
      input = %w[
        12
        67
      ]
      expected = %w[
        12
        67
        23
        78
        34
        89
        45
        91
        56
        12
      ]
      actual = map_expand.expand_to_y(input)
      expect(actual).to eql expected
    end
  end

  describe '::expand' do
    it 'can expand the small example map correctly' do
      input = ['8']
      expected = small_expanded_map_example
      actual = map_expand.expand(input)

      expect(actual).to eql(expected)
    end
    it 'can expand a map of 1x2 correctly' do
      input = %w[12]
      expected = %w[
        1223344556
        2334455667
        3445566778
        4556677889
        5667788991
      ]
      actual = map_expand.expand(input)

      expect(actual).to eql(expected)
    end

    it 'can expand a map of 2x2 correctly' do
      input = %w[12 67]
      expected = %w[
        1223344556
        6778899112
        2334455667
        7889911223
        3445566778
        8991122334
        4556677889
        9112233445
        5667788991
        1223344556
      ]
      actual = map_expand.expand(input)

      expect(actual).to eql(expected)
    end

    it 'can expand the example map correctly' do
      examples = load_example_file(15, /\w+:/)

      input = examples[0]
      expected_output = examples[1]
      actual = map_expand.expand(input)

      expect(actual).to eql(expected_output)
    end
  end
end
