def total_cost(crab_positions, align_at)
  # return 0 if crab_positions.empty?
  crab_positions.map do |position|
    (position - align_at).abs
  end.sum
end

def parse_input(input_string)
  input_string.split(',').map(&:to_i)
end

def find_optimal_position(crab_positions)
  range = (crab_positions.min)..(crab_positions.max)
  optimal_position = range.min_by do |position|
    total_cost(crab_positions, position)
  end

  total_fuel_cost = total_cost(crab_positions, optimal_position)

  expected_output = {
    optimal_position: optimal_position,
    total_fuel_cost: total_fuel_cost
  }
end

def find_optimal_position_gss(crab_positions)
  f = ->(position) { total_cost(crab_positions, position) }

  start = crab_positions.min
  stop = crab_positions.max
  x1 = (stop - (stop - start) * 0.618).round
  x2 = (start + (stop - start) * 0.618).round

  while stop - start >= 4
    if f[x1] < f[x2]
      x2, stop = x1, x2
      x1 = (stop - (stop - start) * 0.618).round
    else
      start, x1 = x1, x2
      x2 = (start + (stop - start) * 0.618).round
    end
  end

  optimal_position = [start, x1, x2, stop].min_by(&f)
  total_fuel_cost = total_cost(crab_positions, optimal_position)

  expected_output = {
    optimal_position: optimal_position,
    total_fuel_cost: total_fuel_cost
  }
end

if __FILE__ == $PROGRAM_NAME
  require_relative './utils'
  input_array = read_input_file(7, 'string')
  raise if input_array.length > 1

  crab_position = parse_input(input_array.first)
  part_a_solution = find_optimal_position(crab_position)
  puts "solution for part A: #{part_a_solution}"
  puts "by golden section search: #{find_optimal_position_gss(crab_position)}"

  require 'benchmark'

  Benchmark.bm do |x|
    x.report { find_optimal_position(crab_position) }
    x.report { find_optimal_position_gss(crab_position) }
  end

  # part_b_solution = predict_fish_counts(input_string, 256)
  # puts "solution for part B: #{part_b_solution}"
end
