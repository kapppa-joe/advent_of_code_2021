require 'puzzle_day19'
require 'matrix'

describe Day19::ScannersMapper do
  def vec(arr)
    # helper func to input a vector from literal
    Matrix.column_vector(arr)
  end

  describe '::parse_input_list' do
    it 'convert the puzzle input into a list of Scanner objects, each populated with initial beacon coord' do
      input_list = [
        '--- scanner 0 ---',
        '404,-588,-901',
        '528,-643,409',
        '',
        '--- scanner 1 ---',
        '649,640,665',
        '682,-795,504',
        '',
        '--- scanner 2 ---',
        '-589,542,597',
        '605,-692,669',
      ]

      output = described_class.parse_input_list(input_list)
      expect(output.length).to eq 3
      expect(output).to all be_a(Day19::Scanner)
      expect(output[0].beacons).to include(vec([404,-588,-901]))
      expect(output[1].beacons).to include(vec([682,-795,504]))
      expect(output[2].beacons).to include(vec([-589,542,597]))
    end
  end
end

describe Day19::Scanner do
  describe '::parse_beacon_coord' do
    it 'convert a list of coordinates into a list of vectors' do
      input_list = %w[
        404,-588,-901
        528,-643,409
      ]
      expected = [
        Matrix[[404], [-588], [-901]],
        Matrix[[528], [-643], [409]]
      ]

      actual = described_class.parse_beacon_coord(input_list)

      expect(actual).to eq expected
    end
  end
end
