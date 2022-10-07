require 'matrix'

module Day19
  class ScannersMapper
    attr_reader :stations

    def self.parse_input_list(input_list)
      current_scanner = nil

      grouped_data = input_list.group_by do |line|
        case line
        when /--- scanner (\d+) ---/
          current_scanner = line.scan(/--- scanner (\d+) ---/)[0][0].to_i
          nil
        when /[-\d]+,[-\d]+,[-\d]+/
          current_scanner
        end
      end
      grouped_data.delete(nil)

      grouped_data.sort.map { |_, beacons| Scanner.new(beacons) }
    end

    def initialize(input_list)
      @stations = self.class.parse_input_list(input_list)
    end

    def common_beacons_between_stations(a, b)
      # locate the common beacons between two stations,
      #  using the fact that inter-beacon distance remain the same no matter observed from which station
      relation_map = {}
      stations[a].interbeacon_distances.each_with_index do |dist_a, index_from_a|
        stations[b].interbeacon_distances.each_with_index do |dist_b, index_from_b|
          common_interbeacon_distances = dist_a & dist_b
          relation_map[index_from_a] = index_from_b if common_interbeacon_distances.length >= 11
        end
      end
      relation_map
    end

    def create_coordinate_convertor(base, neighbour, relation_map)
      base_station = @stations[base]
      neighbour_station = @stations[neighbour]

      a, b, c, d = relation_map.take(2).flatten
      station_a_beacon_1, station_a_beacon_2 = base_station[a], base_station[c]
      station_b_beacon_1, station_b_beacon_2 = neighbour_station[b], neighbour_station[d]

      distance_vec_station_a = station_a_beacon_2 - station_a_beacon_1
      distance_vec_station_b = station_b_beacon_2 - station_b_beacon_1
      rotation_matrix = create_rotation_matrix(distance_vec_station_a, distance_vec_station_b)
      reverse_rotation_matrix = rotation_matrix.inverse.map(&:to_i)

      station_b_beacon_1_rotated = rotation_matrix * station_b_beacon_1
      translation_component = station_a_beacon_1 - station_b_beacon_1_rotated

      to_base = ->(vec) { rotation_matrix * vec + translation_component }
      from_base = ->(vec) { reverse_rotation_matrix * (vec - translation_component)}
      
      return to_base, from_base
    end

    def create_rotation_matrix(vec1, vec2)
      vec1, vec2 = [vec1, vec2].map { |vec| vec.to_a.flatten }

      rows_of_rotation_matrix = vec1.map do |vec1_component|
        position_in_vec2 = vec2.map(&:abs).index(vec1_component.abs)
        raise 'error when trying to create rotation matrix' if position_in_vec2.nil?

        row = [0, 0, 0]
        row[position_in_vec2] = vec1_component / vec2[position_in_vec2]
        row
      end

      Matrix.rows(rows_of_rotation_matrix)
    end

    def build_stations_map
      all_combinations = @stations.length.times.to_a.combination(2)

      @inter_station_map = Hash.new { |h, k| h[k] = [] }
      @beacons_relationship_map = Hash.new { |h, k| h[k] = [] }

      all_combinations.each do |a, b|
        relation_map = common_beacons_between_stations(a, b)
        next if relation_map.empty?

        @inter_station_map[a] << b
        @inter_station_map[b] << a
        @beacons_relationship_map["#{a}->#{b}"] = relation_map
      end

      @inter_station_map
    end

    def beacon_coords_to_string(list_of_vectors)
      list_of_vectors.map { |vector| vector.to_a.flatten.to_s.tr('[] ', '') }
    end

    def build_coordinate_convertors
      puts build_stations_map
    end

    def build_all_beacons_list
      build_stations_map
      build_coordinate_convertors
      []
    end
  end

  class Scanner
    attr_reader :beacons, :interbeacon_distances

    def self.parse_beacon_coord(input_list)
      input_list.map do |coord_string|
        coord = coord_string.split(',').map(&:to_i)
        Matrix.column_vector(coord)
      end
    end

    def initialize(input_list)
      @beacons = self.class.parse_beacon_coord(input_list)
      length = @beacons.length
      @interbeacon_distances = length.times.map { [0] * length }
      # populate interbeacon distances
      length.times.to_a.combination(2).each { |a, b| distance_between_beacons(a, b) }
    end

    def distance_between_beacons(a, b)
      return @interbeacon_distances[a][b] unless @interbeacon_distances[a][b].zero?
      return 0 if a == b

      distance = (@beacons[a] - @beacons[b]).to_a.flatten.map { |num| num**2 }.sum
      @interbeacon_distances[a][b] = distance
      @interbeacon_distances[b][a] = distance
    end

    def beacon_coords_to_string
      @beacons.map { |vector| vector.to_a.flatten.to_s.tr('[] ', '') }
    end

    def [](key)
      raise ArgumentError unless key < @beacons.length

      @beacons[key]
    end
  end
end
