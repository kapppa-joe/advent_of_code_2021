require 'matrix'

module Day19
  class ScannersMapper
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

      grouped_data.sort.map {|_, beacons| Scanner.new(beacons)}
    end
  end

  class Scanner
    attr_reader :beacons

    def self.parse_beacon_coord(input_list)
      input_list.map do |coord_string|
        coord = coord_string.split(',').map(&:to_i)
        Matrix.column_vector(coord)
      end
    end

    def initialize(input_list)
      @beacons = self.class.parse_beacon_coord(input_list)
    end
  end
end
