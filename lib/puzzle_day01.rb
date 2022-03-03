require_relative './utils'

def count_depth_increase(array)
  0.step(array.length - 2).count do |i|
    array[i + 1] > array[i]
  end
end

if __FILE__ == $PROGRAM_NAME
  input_array = read_input_file(1, 'integer')
  puts "solution: #{count_depth_increase(input_array)}"
end
