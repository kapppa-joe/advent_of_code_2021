require 'puzzle_day19'
require 'matrix'
require 'utils'

describe 'Day19' do
  Day19Examples = load_example_file(19, /\w+:/)
  Day19SmallerExample = Day19Examples[0]
  Day19LargerExample = Day19Examples[1]
  Day19LargerExampleSolution = Day19Examples[2]

  describe Day19::ScannersMapper do
    def vec(arr)
      # helper func to input a vector from literal
      Matrix.column_vector(arr)
    end

    let(:larger_example) { described_class.new(Day19LargerExample) }

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
          '605,-692,669'
        ]

        output = described_class.parse_input_list(input_list)
        expect(output.length).to eq 3
        expect(output).to all be_a(Day19::Scanner)
        expect(output[0].beacons).to include(vec([404, -588, -901]))
        expect(output[1].beacons).to include(vec([682, -795, 504]))
        expect(output[2].beacons).to include(vec([-589, 542, 597]))
      end
    end

    describe '#common_beacons_between_stations' do
      it 'returns a hash map of common beacons between two stations' do
        output = larger_example.common_beacons_between_stations(0, 1)
        expect(output.length).to eq 12
        expect(output[0])
      end

      it 'generates a correct relationship map of beacons' do
        beacon_coords_of_station_0 = larger_example.stations[0].beacon_coords_to_string
        beacon_coords_of_station_1 = larger_example.stations[1].beacon_coords_to_string

        given_common_beacons_station_0 = %w[
          -618,-824,-621
          -537,-823,-458
          -447,-329,318
          404,-588,-901
          544,-627,-890
          528,-643,409
          -661,-816,-575
          390,-675,-793
          423,-701,434
          -345,-311,381
          459,-707,401
          -485,-357,347
        ]

        given_common_beacons_station_1 = %w[
          686,422,578
          605,423,415
          515,917,-361
          -336,658,858
          -476,619,847
          -460,603,-452
          729,430,532
          -322,571,750
          -355,545,-477
          413,935,-424
          -391,539,-444
          553,889,-390
        ]

        indices_of_station_0 = given_common_beacons_station_0.map do |str|
          beacon_coords_of_station_0.find_index do |coord|
            coord.include?(str)
          end
        end
        indices_of_station_1 = given_common_beacons_station_1.map do |str|
          beacon_coords_of_station_1.find_index do |coord|
            coord.include?(str)
          end
        end

        expected = indices_of_station_0.zip(indices_of_station_1).to_h

        actual = larger_example.common_beacons_between_stations(0, 1)
        expect(actual).to eq expected
      end

      it 'returns an empty hash if two station are not neighboured' do
        base_station = 0
        neighbour_station = 2

        expected = {}
        actual = larger_example.common_beacons_between_stations(base_station, neighbour_station)

        expect(actual).to eq expected
      end
    end

    describe '#create_coordinate_convertor' do
      it 'returns convertor functions that interchange coordinates of two stations' do
        base_station = 0
        neighbour_station = 1
        relation_map = { 0 => 3, 1 => 8, 3 => 12, 4 => 1, 5 => 24, 6 => 18, 7 => 10, 9 => 0, 12 => 2, 14 => 5,
                         19 => 15, 24 => 19 }

        b_to_a, a_to_b = larger_example.create_coordinate_convertor(
          base_station, neighbour_station, relation_map
        )

        expect(a_to_b).is_a?(Proc)
        expect(b_to_a).is_a?(Proc)

        relation_map.each do |base_key, neighbour_key|
          base_beacon = larger_example.stations[base_station].beacons[base_key]
          neighbour_beacon = larger_example.stations[neighbour_station].beacons[neighbour_key]
          expect(a_to_b.call(base_beacon)).to eq neighbour_beacon
          expect(b_to_a.call(neighbour_beacon)).to eq base_beacon
        end
      end

      it 'another example' do
        base_station = 1
        neighbour_station = 4
        relation_map = larger_example.common_beacons_between_stations(base_station, neighbour_station)

        b_to_a, a_to_b = larger_example.create_coordinate_convertor(
          base_station, neighbour_station, relation_map
        )

        expect(a_to_b).is_a?(Proc)
        expect(b_to_a).is_a?(Proc)

        relation_map.each do |base_key, neighbour_key|
          base_beacon = larger_example.stations[base_station].beacons[base_key]
          neighbour_beacon = larger_example.stations[neighbour_station].beacons[neighbour_key]
          expect(a_to_b.call(base_beacon)).to eq neighbour_beacon
          expect(b_to_a.call(neighbour_beacon)).to eq base_beacon
        end
      end
    end

    describe '#create_rotation_matrix' do
      it 'create a matrix that denote the orientation change by comparing the same distance vectors observed from two stations' do
        input = [Matrix[[124], [-55], [1310]], Matrix[[-124], [-55], [-1310]]]
        expected = Matrix[
          [-1, 0, 0],
          [0, 1, 0],
          [0, 0, -1]
        ]

        actual = larger_example.create_rotation_matrix(*input)
        expect(actual).to eq expected
      end

      it 'can handle case of rotated orientation' do
        input = [Matrix[[-855], [-1486], [-485]], Matrix[[485], [-855], [1486]]]
        expected = Matrix[[0, 1, 0], [0, 0, -1], [-1, 0, 0]]

        actual = larger_example.create_rotation_matrix(*input)
        expect(actual).to eq expected
      end
    end

    describe '#build_stations_map' do
      it 'return the neighbouring relationship of stations' do
        expected = {
          0 => [1],
          1 => [0, 3, 4],
          2 => [4],
          3 => [1],
          4 => [1, 2]
        }

        actual = larger_example.build_stations_map

        expect(actual).to eq expected
      end
    end

    xdescribe '#build_all_beacons_list' do
      it 'return a list of all beacons relative to scanner 0 with no duplications' do
        actual = larger_example.build_all_beacons_list
        expected = Day19LargerExampleSolution

        expect(actual.length).to eq 79
        # expect(actual).to eq expected
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

    let(:basicScanner) { described_class.new(Day19SmallerExample[1..6]) }

    describe '#distance_between_beacons' do
      describe 'return the between two beacons' do
        it 'basic example' do
          # distance between -1,-1,1 and -2,-2,2

          expected = 3 # for convenience, don't take the sqaure root
          actual = basicScanner.distance_between_beacons(0, 1)

          expect(actual).to eq expected
        end

        it 'basic example 2' do
          # distance between -1,-1,1 and 5, 6, -4

          expected = 110  # for convenience, don't take the sqaure root
          actual = basicScanner.distance_between_beacons(0, 4)

          expect(actual).to eq expected
        end
      end
    end
  end
end
