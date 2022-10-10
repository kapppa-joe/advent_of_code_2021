require 'matrix'

module Day19
  class ScannersMapper
    attr_reader :stations, :all_beacons

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
      @station_positions = []
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
      from_base = ->(vec) { reverse_rotation_matrix * (vec - translation_component) }

      [to_base, from_base]
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

    def combination_of_two_stations
      @stations.length.times.to_a.combination(2)
    end

    def build_stations_map
      @inter_station_map ||= Hash.new { |h, k| h[k] = [] }
      @beacons_relationship_map ||= Hash.new { |h, k| h[k] = [] }
      @convertors ||= Hash.new { |h, k| h[k] = [] }

      combination_of_two_stations.each do |a, b|
        relation_map = common_beacons_between_stations(a, b)
        next if relation_map.empty?

        build_map_between_two_stations(a, b, relation_map)
      end

      @inter_station_map
    end

    def build_map_between_two_stations(a, b, relation_map)
      @inter_station_map[a] << b
      @inter_station_map[b] << a
      @beacons_relationship_map["#{a}->#{b}"] = relation_map
      convertor_b_to_a, convertor_a_to_b = create_coordinate_convertor(a, b, relation_map)
      @convertors["#{a}->#{b}"] = convertor_a_to_b
      @convertors["#{b}->#{a}"] = convertor_b_to_a
    end

    def beacon_coords_to_string(list_of_vectors)
      list_of_vectors.map { |vector| vector.to_a.flatten.to_s.tr('[] ', '') }
    end

    def build_coordinate_convertors
      build_stations_map
    end

    def find_route_to_origin(starting_station, stations_map)
      goal = 0
      return [] if starting_station == goal

      current_station = starting_station
      visited = []
      queue = stations_map[current_station].map { |next_station| [starting_station, next_station] }

      until queue.empty?
        route = queue.shift
        current_station = route.last
        neighbours = stations_map[current_station] - visited
        return route if current_station == goal

        visited.push(current_station)

        neighbours.each do |neighbour|
          queue.push(route + [neighbour])
        end
      end

      raise 'Fail to find a route to origin'
    end

    def get_convertor(a, b)
      raise unless @convertors["#{a}->#{b}"]

      @convertors["#{a}->#{b}"]
    end

    def beacon_coords_relative_to_origin(station_num)
      build_stations_map unless @inter_station_map

      route = find_route_to_origin(station_num, @inter_station_map)
      convertors_to_apply = route.each_cons(2).map { |a, b| get_convertor(a, b) }

      @stations[station_num].beacons.map do |vec|
        convertors_to_apply.each do |convertor|
          vec = convertor.call(vec)
        end
        vec
      end
    end

    def build_all_beacons_list
      build_stations_map
      @all_beacons = @stations[0].beacons.clone
      (1...@stations.length).each do |station_num|
        @all_beacons.push(*beacon_coords_relative_to_origin(station_num))
      end

      @all_beacons.uniq!
      @all_beacons
    end

    def station_position(station_num)
      return @station_positions[station_num] if @station_positions.include?(station_num)

      build_stations_map unless @inter_station_map

      route = find_route_to_origin(station_num, @inter_station_map)
      convertors_to_apply = route.each_cons(2).map { |a, b| get_convertor(a, b) }
      result = convertors_to_apply.reduce(Matrix.column_vector([0, 0, 0])) do |vec, convertor|
        convertor.call(vec)
      end

      @station_positions[station_num] = result
    end

    def manhattan_distance(point_a, point_b)
      (point_a - point_b).to_a.flatten.map(&:abs).sum
    end

    def max_manhattan_distance_between_two_stations
      pair_with_distances = combination_of_two_stations.map do |a, b|
        {
          stations: [a, b],
          manhattan_distance: manhattan_distance(station_position(a), station_position(b))
        }
      end

      pair_with_distances.max_by { |pair| pair[:manhattan_distance] }
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

if __FILE__ == $PROGRAM_NAME
  require_relative './utils'
  input_array = read_input_file(19, 'string')
  stations_mapper = Day19::ScannersMapper.new(input_array)
  stations_mapper.build_all_beacons_list

  part_a_solution = stations_mapper.all_beacons.length
  puts "solution for part A: #{part_a_solution}"

  part_b_solution = stations_mapper.max_manhattan_distance_between_two_stations
  puts "solution for part B: #{part_b_solution}"

end
