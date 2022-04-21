module Day15
  class Chiton
    def initialize(input_map = [''])
      @map = parse_input(input_map)
      @x_limit = @map.first.size
      @y_limit = @map.size
    end

    def parse_input(input_array)
      input_array.map do |rows|
        rows.chars.map(&:to_i)
      end
    end

    def value_of(x, y)
      @map[y][x]
    end

    def each_neighbour_of(x, y)
      return to_enum(:each_neighbour_of, x, y) unless block_given?

      yield [x + 1, y] if x < @x_limit - 1
      yield [x, y + 1] if y < @y_limit - 1
      yield [x - 1, y] if x >= 1
      yield [x, y - 1] if y >= 1
    end

    def values_of_each_neighbour(x, y)
      return to_enum(:values_of_each_neighbour, x, y) unless block_given?

      each_neighbour_of(x, y).each do |coordinate|
        yield value_of(*coordinate)
      end
    end

    def lowest_risk_path(start, goal)
      total_score = 0
      scores = {}
      curr = start
      # next_nodes = 

      return total_score if start == goal

      (x, y) = goal
      @map[y][x]
    end
  end
end

