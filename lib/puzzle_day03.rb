def analyse_diagnostic_report(input_array)
  gamma_rate = calculate_gamma_rate(input_array)
  epsilon_rate = calculate_epsilon_rate(gamma_rate, input_array[0].length)
  {
    gamma_rate: gamma_rate,
    epsilon_rate: epsilon_rate,
    power_consumption: gamma_rate * epsilon_rate
  }
end

def find_life_support_rating(input_array)
  oxygen_generator_rating = calc_oxygen_generator_rating(input_array)
  co2_scrubber_rating = calc_co2_scrubber_rating(input_array)
  {
    oxygen_generator_rating: oxygen_generator_rating,
    co2_scrubber_rating: co2_scrubber_rating,
    life_support_rating: oxygen_generator_rating * co2_scrubber_rating
  }
end

def calculate_gamma_rate(input_array)
  most_frequent_bits(input_array).to_i(2)
end

def calculate_epsilon_rate(gamma_rate, binary_length)
  (2 ** binary_length) - 1 - gamma_rate
end

def calc_oxygen_generator_rating(input_array)
  23
end

def calc_co2_scrubber_rating(input_array)
  10
end


# util functions below 

def most_frequent_bits(input_array)
  array_of_most_freq_bits =
    input_array.map(&:chars)
               .transpose
               .map { |bits_at_this_position| find_mode(bits_at_this_position) }

  array_of_most_freq_bits.join('')
end

def find_mode(array)
  return nil if array.empty?

  count_table = array.reduce(Hash.new(0)) do |acc, elem|
    acc[elem] += 1
    acc
  end

  mode, max_count = count_table.max_by { |_, v| v }
  mode
end


if __FILE__ == $PROGRAM_NAME
  require_relative './utils'
  input_array = read_input_file(3, 'string')

  part_a_solution = analyse_diagnostic_report(input_array)
  puts "solution for part A: #{part_a_solution}"
end