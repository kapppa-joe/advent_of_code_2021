module Day09
  class SmokeBasin
    def initialize(input_array)
      @map = parse_input(input_array)
      @x_limit = @map.first.size
      @y_limit = @map.size
    end

    def parse_input(input_array)
      input_array.map { |str| str.chars.map(&:to_i) }
    end

    def [](x, y)
      @map[y][x]
    end

    def each_neighbour_of(x, y)
      return to_enum(:each_neighbour_of, x, y) unless block_given?

      yield self[x + 1, y] if x < @x_limit - 1
      yield self[x, y + 1] if y < @y_limit - 1
      yield self[x - 1, y] if x >= 1
      yield self[x, y - 1] if y >= 1
    end

    def low_point?(x, y)
      self_height = self[x, y]
      each_neighbour_of(x, y).all? do |neighbour_height|
        neighbour_height > self_height
      end
    end

    def find_all_low_points
      all_points = (0...@x_limit).to_a.product((0...@y_limit).to_a)
      all_points.filter { |x, y| low_point?(x, y) }
    end

    def sum_risk_factor
      find_all_low_points.map do |x, y|
        self[x, y] + 1
      end.sum
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  require_relative './utils'
  input_array = read_input_file(9, 'string')

  part_a_solution = Day09::SmokeBasin.new(input_array).sum_risk_factor
  puts "solution for part A: #{part_a_solution}"

  # part_b_solution = Day08.sum_all_decoded_outputs(input_array)
  # puts "solution for part B: #{part_b_solution}"
end
