require 'set'

module Day11
  class DumboOctopus
    attr_reader :octopus, :total_flash_count

    def initialize(input_array)
      @octopus = parse_input(input_array)
      @x_limit, @y_limit = @octopus.keys.max
      @total_flash_count = 0
      @turn = 0
    end

    def parse_input(input_array)
      octopus = {}
      input_array.each_with_index do |string, y|
        string.chars.each_with_index do |char, x|
          octopus[[x, y]] = char.to_i
        end
      end
      octopus
    end

    def each_neighbour_of(x, y, &block)
      raise IndexError if @octopus[[x, y]].nil?
      return to_enum(:each_neighbour_of, x, y) unless block_given?

      neighbours = [x - 1, x, x + 1].product([y - 1, y, y + 1])
      neighbours.filter! do |x1, y1|
        valid_coordinate?(x1, y1) && [x1, y1] != [x, y]
      end

      neighbours.each do |coordinate|
        block.call(coordinate)
      end
    end

    def valid_coordinate?(x, y)
      return false if x.negative? || y.negative?
      return false if x > @x_limit || y > @y_limit

      true
    end

    def increase_energy_for_all
      @octopus.each do |k, v|
        @octopus[k] = v + 1
      end
    end

    def energy_of(coord)
      @octopus[coord]
    end

    def energy_level_over_9
      @octopus.keys.filter { |coord| energy_of(coord) > 9 }
    end

    def reset_energy_level_to_0
      energy_level_over_9.each do |coord|
        @octopus[coord] = 0
      end
    end

    def flash_at(coordinates)
      coordinates.each do |x, y|
        each_neighbour_of(x, y) do |neighbour_coord|
          @octopus[neighbour_coord] += 1
        end
      end
    end

    def next_turn
      increase_energy_for_all
      @turn += 1
      already_flashed = []
      octopus_ready_to_flash = energy_level_over_9 - already_flashed

      until octopus_ready_to_flash.empty?
        flash_at(octopus_ready_to_flash)
        already_flashed += octopus_ready_to_flash
        octopus_ready_to_flash = energy_level_over_9 - already_flashed
      end

      reset_energy_level_to_0
      flash_count = already_flashed.length
      @total_flash_count += flash_count

      { flash_count: flash_count, turn: @turn }
    end

    def next_sync_flash
      curr_flash_count = 0
      while curr_flash_count != @octopus.length
        curr_flash_count = next_turn[:flash_count]
      end
      @turn
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  require_relative './utils'
  input_array = read_input_file(11, 'string')

  dumbo = Day11::DumboOctopus.new(input_array)
  100.times { dumbo.next_turn }
  part_a_solution = dumbo.total_flash_count
  puts "solution for part A: #{part_a_solution}"
  # 100.times { dumbo.next_turn }

  dumbo = Day11::DumboOctopus.new(input_array)
  part_b_solution = dumbo.next_sync_flash
  puts "solution for part B: #{part_b_solution}"
end
