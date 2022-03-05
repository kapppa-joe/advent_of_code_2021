def analyse_diagnostic_report(input_array)
  gamma_rate = find_gamma_rate(input_array)
  epsilon_rate = find_epsilon_rate(gamma_rate, input_array[0].length)
  {
    gamma_rate: gamma_rate,
    epsilon_rate: epsilon_rate,
    power_consumption: gamma_rate * epsilon_rate
  }
end

def find_life_support_rating(input_array)
  oxygen_generator_rating = find_oxygen_generator_rating(input_array)
  co2_scrubber_rating = find_co2_scrubber_rating(input_array)
  {
    oxygen_generator_rating: oxygen_generator_rating,
    co2_scrubber_rating: co2_scrubber_rating,
    life_support_rating: oxygen_generator_rating * co2_scrubber_rating
  }
end

def find_gamma_rate(input_array)
  most_frequent_bits(input_array).to_i(2)
end

def find_epsilon_rate(gamma_rate, binary_length)
  (2 ** binary_length) - 1 - gamma_rate
end

def find_oxygen_generator_rating(input_array)
  repeated_filter(input_array).to_i(2)
end

def least_frequent_single_bit(current_bits)
  most_freq_bit = most_frequent_single_bit(current_bits)
  most_freq_bit == '1' ? '0' : '1'
end

def find_co2_scrubber_rating(input_array)
  binary_num_result = repeated_filter(input_array) do |current_bits|
    least_frequent_single_bit(current_bits)
  end
  binary_num_result.to_i(2)
end

def repeated_filter(input_array)
  bit_length = input_array.first.length
  current_array = input_array

  bit_length.times do |i|
    current_bits = current_array.map { |binary_num| binary_num[i] }
    if block_given?
      chosen_bit = yield current_bits
    else
      chosen_bit = most_frequent_single_bit(current_bits)
    end
    current_array = current_array.filter { |binary_num| binary_num[i] == chosen_bit }
    break if current_array.length == 1
  end

  current_array.first
end


# util functions below

def most_frequent_bits(input_array)
  array_of_most_freq_bits =
    input_array.map(&:chars)
               .transpose
               .map { |bits| most_frequent_single_bit(bits) }

  array_of_most_freq_bits.join('')
end

# === deprecated because part B requires to prefer 1 when same frequency ===
# def find_mode(array)
#   return nil if array.empty?

#   count_table = array.reduce(Hash.new(0)) do |acc, elem|
#     acc[elem] += 1
#     acc
#   end

#   mode, max_count = count_table.max_by { |_, v| v }
#   mode
# end

def most_frequent_single_bit(array)
  return nil if array.empty?
  return '0' if array.map(&:to_i).sum < array.length / 2.0

  '1'
end

if __FILE__ == $PROGRAM_NAME
  require_relative './utils'
  input_array = read_input_file(3, 'string')

  part_a_solution = analyse_diagnostic_report(input_array)
  puts "solution for part A: #{part_a_solution}"

  part_b_solution = find_life_support_rating(input_array)
  puts "solution for part B: #{part_b_solution}"
end
