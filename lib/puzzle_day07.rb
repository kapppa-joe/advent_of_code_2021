def total_cost(crab_positions, align_at)
  crab_positions.map do |position|
    (position - align_at).abs
  end.sum
end

def non_linear_fuel_cost(start, stop)
  distance = (stop - start).abs
  distance * (distance + 1) / 2
end

def non_linear_total_cost(crab_positions, align_at)
  crab_positions.map do |position|
    non_linear_fuel_cost(position, align_at)
  end.sum
end

def parse_input(input_string)
  input_string.split(',').map(&:to_i)
end

def find_optimal_position(crab_positions, linear: true)
  if linear
    fuel_function = ->(align_at) { total_cost(crab_positions, align_at) }
  else
    fuel_function = ->(align_at) { non_linear_total_cost(crab_positions, align_at) }
  end

  range = (crab_positions.min)..(crab_positions.max)
  fuel_costs_of_every_cases = range.each_with_object({}) do |align_at, hash|
    hash[align_at] = fuel_function.call(align_at)
  end

  optimal_position, total_fuel_cost =
    fuel_costs_of_every_cases.min_by { |_, v| v }

  expected_output = {
    optimal_position: optimal_position,
    total_fuel_cost: total_fuel_cost
  }
end

def find_optimal_position_gss(crab_positions, linear: true)
  if linear
    fuel_function = ->(align_at) { total_cost(crab_positions, align_at) }
  else
    fuel_function = ->(align_at) { non_linear_total_cost(crab_positions, align_at) }
  end

  start = crab_positions.min
  stop = crab_positions.max
  x1 = (stop - (stop - start) * 0.618).round
  x2 = (start + (stop - start) * 0.618).round

  while stop - start >= 4
    if fuel_function[x1] < fuel_function[x2]
      x2, stop = x1, x2
      x1 = (stop - (stop - start) * 0.618).round
    else
      start, x1 = x1, x2
      x2 = (start + (stop - start) * 0.618).round
    end
  end

  optimal_position = [start, x1, x2, stop].min_by(&fuel_function)
  total_fuel_cost = fuel_function.call(optimal_position)

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


  part_b_solution = find_optimal_position(crab_position, linear: false)
  puts "solution for part B: #{part_b_solution}"
  puts "by golden section search: #{find_optimal_position_gss(crab_position, linear: false)}"

  require 'benchmark'

  Benchmark.bm do |x|
    x.report { find_optimal_position(crab_position) }
    x.report { find_optimal_position_gss(crab_position) }

    x.report { find_optimal_position(crab_position, linear: false) }
    x.report { find_optimal_position_gss(crab_position, linear: false) }
  end
end
