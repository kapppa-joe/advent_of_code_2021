require_relative './utils'

def count_depth_increase(array)
  0.step(array.length - 2).count do |i|
    array[i + 1] > array[i]
  end
end

def sum_sliding_windows(array)
  window_size = 3
  0.step(array.length - window_size).map do |start_index|
    array[start_index, window_size].sum
  end
end

def count_increase_by_sliding_window(array)
  count_depth_increase(sum_sliding_windows(array))
end

if __FILE__ == $PROGRAM_NAME
  input_array = read_input_file(1, 'integer')
  puts "solution for part A: #{count_depth_increase(input_array)}"
  puts "solution for part B: #{count_increase_by_sliding_window(input_array)}"
end
