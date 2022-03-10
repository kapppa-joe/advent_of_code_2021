require 'set'

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
      height_at(x, y)
    end

    def height_at(x, y)
      @map[y][x]
    end

    def each_neighbour_of(x, y)
      return to_enum(:each_neighbour_of, x, y) unless block_given?

      yield [x + 1, y] if x < @x_limit - 1
      yield [x, y + 1] if y < @y_limit - 1
      yield [x - 1, y] if x >= 1
      yield [x, y - 1] if y >= 1
    end

    def height_of_each_neighbour(x, y)
      return to_enum(:height_of_each_neighbour, x, y) unless block_given?

      each_neighbour_of(x, y).each do |coordinate|
        yield height_at(*coordinate)
      end
    end

    def low_point?(x, y)
      self_height = self[x, y]
      height_of_each_neighbour(x, y).all? do |neighbour_height|
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

    def measure_basin_at(x, y, seen = Set.new)
      return 0 if seen.include?([x, y]) || height_at(x, y) == 9

      seen.add([x, y])
      area = 1
      each_neighbour_of(x, y) do |x1, y1|
        area += measure_basin_at(x1, y1, seen)
      end
      area
    end

    def find_all_basins
      starting_points = find_all_low_points
      seen = Set.new
      basins = {}
      starting_points.each do |x, y|
        basins[[x, y]] = measure_basin_at(x, y, seen)
      end

      basins
    end

    def largest_basins_area_product
      basins = find_all_basins
      top_three_area = basins.map { |_, area| area }
                             .sort
                             .reverse!
                             .take(3)
      top_three_area.reduce(&:*)
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  require_relative './utils'
  input_array = read_input_file(9, 'string')
  smoke_basin = Day09::SmokeBasin.new(input_array)

  part_a_solution = smoke_basin.sum_risk_factor
  puts "solution for part A: #{part_a_solution}"

  part_b_solution = smoke_basin.largest_basins_area_product
  puts "solution for part B: #{part_b_solution}"
end
