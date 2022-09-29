require 'set'

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

    def lowest_risk_path(start, goal = nil)
      goal = [@x_limit - 1, @y_limit - 1] if goal.nil?

      return 0 if start == goal

      scores = {}
      scores[start] = 0

      visited = Set[]
      to_visit = [start]

      until to_visit.empty?
        curr = to_visit.pop
        visited.add(curr)
        # return scores[goal] if curr == goal

        next_nodes = each_neighbour_of(*curr)
        next_nodes.each do |coord|
          new_score = value_of(*coord) + scores[curr]
          scores[coord] = [new_score, scores.fetch(coord, Float::INFINITY)].min
          to_visit.push(coord) unless visited.include?(coord)
        end

        return scores[goal] if scores.key?(goal)

        to_visit = to_visit.uniq.sort_by { |coord| scores[coord] }.reverse
      end
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  require_relative './utils'
  input_array = read_input_file(15, 'string')
  chiton = Day15::Chiton.new(input_array)

  part_a_solution = chiton.lowest_risk_path([0, 0])
  puts "solution for part A: #{part_a_solution}"

end
