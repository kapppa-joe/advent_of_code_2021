require 'puzzle_day09'

example_input_of_day_09 = [
  '2199943210',
  '3987894921',
  '9856789892',
  '8767896789',
  '9899965678'
]

describe Day09::SmokeBasin do
  let(:smoke_basin) { described_class.new(example_input_of_day_09) }

  describe '#parse_input' do
    it 'convert the height map input into a nested array of integer' do
      input = example_input_of_day_09
      expected_output = [
        [2, 1, 9, 9, 9, 4, 3, 2, 1, 0],
        [3, 9, 8, 7, 8, 9, 4, 9, 2, 1],
        [9, 8, 5, 6, 7, 8, 9, 8, 9, 2],
        [8, 7, 6, 7, 8, 9, 6, 7, 8, 9],
        [9, 8, 9, 9, 9, 6, 5, 6, 7, 8]
      ]

      expect(smoke_basin.parse_input(input)).to eql expected_output
    end
  end

  describe '#[]' do
    it 'return the height value at coordinate (x, y)' do
      expect(smoke_basin[0, 0]).to eql 2
      expect(smoke_basin[0, 1]).to eql 3
      expect(smoke_basin[1, 0]).to eql 1
      expect(smoke_basin[4, 2]).to eql 7
    end
  end

  describe '#height_of_each_neighbour' do
    it 'yield the values of (1, 0), (0, 1) when given (0, 0)' do
      input = [0, 0]
      expected_yield_args = [1, 3]

      expect do |block|
        smoke_basin.height_of_each_neighbour(*input, &block)
      end.to yield_successive_args(*expected_yield_args)
    end

    it 'yield the values of (8, 0), (7, 1), (6, 0) when given (7, 0)' do
      input = [7, 0]
      expected_yield_args = [1, 9, 3]

      expect do |block|
        smoke_basin.height_of_each_neighbour(*input, &block)
      end.to yield_successive_args(*expected_yield_args)
    end

    it 'yield the values of (7, 2), (6, 3), (5, 2), (6, 1) when given (6, 2)' do
      input = [6, 2]
      expected_yield_args = [8, 6, 8, 4]

      expect do |block|
        smoke_basin.height_of_each_neighbour(*input, &block)
      end.to yield_successive_args(*expected_yield_args)
    end

    describe 'it yield correctly for coordinate at the edges and corners' do
      test_cases = {
        [9, 0] => [1, 1],
        [9, 1] => [2, 2, 0],
        [9, 4] => [7, 9],
        [5, 4] => [5, 9, 9],
        [0, 4] => [8, 8]
      }
      test_cases.each do |input, expected_yield_args|
        it "test case for #{input}" do
          expect do |block|
            smoke_basin.height_of_each_neighbour(*input, &block)
          end.to yield_successive_args(*expected_yield_args)
        end
      end
    end
  end

  describe '#low_point?' do
    it 'return false if any one of the neighbours are equal to or lower than given cell' do
      test_map = [
        '000',
        '000',
        '000'
      ]
      smoke_basin = described_class.new(test_map)
      expect(smoke_basin.low_point?(1, 1)).to be false
    end

    it 'return true if all neighbours are higher than given cell' do
      test_map = [
        '010',
        '101',
        '010'
      ]
      smoke_basin = described_class.new(test_map)
      expect(smoke_basin.low_point?(1, 1)).to be true
      expect(smoke_basin.low_point?(0, 0)).to be true
      expect(smoke_basin.low_point?(0, 2)).to be true
      expect(smoke_basin.low_point?(2, 0)).to be true
      expect(smoke_basin.low_point?(2, 2)).to be true
    end
  end

  describe '#find_all_low_points' do
    it 'return an array of all low points in the map' do
      expected_output = [
        [1, 0], [9, 0], [2, 2], [6, 4]
      ]
      expect(smoke_basin.find_all_low_points).to match_array expected_output
    end
  end

  describe '#sum_risk_factor' do
    it 'solve the example case correctly' do
      expected_output = 15
      expect(smoke_basin.sum_risk_factor).to eql expected_output
    end
  end

  describe '#measure_basin_at' do
    context 'simple map' do
      test_map = [
        '999',
        '299',
        '191'
      ]

      it 'returns 0 if given coordinate has a height of 9' do
        input = [0, 0]
        expected_output = 0
        actual_output = Day09::SmokeBasin.new(test_map).measure_basin_at(*input)

        expect(actual_output).to eql expected_output
      end

      it 'returns 1 if given coordinate has a height of less than 9 and is surrounded by height 9' do
        input = [2, 2]
        expected_output = 1

        actual_output = Day09::SmokeBasin.new(test_map).measure_basin_at(*input)

        expect(actual_output).to eql expected_output
      end

      it 'returns 0 if given coordinate is included in the set seen' do
        seen = Set.new
        input = [2, 2]
        seen.add(input)
        expected_output = 0

        actual_output = Day09::SmokeBasin.new(test_map).measure_basin_at(*input, seen)

        expect(actual_output).to eql expected_output
      end

      it 'returns 2 if given coordinate is a part of basin with size two' do
        input = [0, 2]
        expected_output = 2

        actual_output = Day09::SmokeBasin.new(test_map).measure_basin_at(*input)

        expect(actual_output).to eql expected_output
      end
    end

    context 'example map' do
      it 'returns 3 for the basin at top left corner' do
        input = [1, 0]
        expected_output = 3

        expect(smoke_basin.measure_basin_at(*input)).to eql expected_output
      end

      it 'returns 9 for the basin at top right corner' do
        input = [9, 0]
        expected_output = 9

        expect(smoke_basin.measure_basin_at(*input)).to eql expected_output
      end

      it 'return 14 for the basin at middle-left' do
        input = [2, 2]
        expected_output = 14

        expect(smoke_basin.measure_basin_at(*input)).to eql expected_output
      end

      it 'return 9 for the basin at bottom right corner' do
        input = [9, 4]
        expected_output = 9

        expect(smoke_basin.measure_basin_at(*input)).to eql expected_output
      end
    end
  end

  describe '#find_all_basins' do
    it 'solve the example case correctly' do
      expected_output = {
        [1, 0] => 3,
        [9, 0] => 9,
        [2, 2] => 14,
        [6, 4] => 9
      }

      expect(smoke_basin.find_all_basins).to eql expected_output
    end
  end

  describe '#largest_basins_area_product' do
    it 'solve the example case correctly' do
      expected_output = 1134
      expect(smoke_basin.largest_basins_area_product).to eql expected_output
    end
  end
end
