def calculate_position_prototype(commands)
  depth = 0
  horizontal = 0

  commands.each do |command|
    direction, number = command.split(' ')
    number = number.to_i

    case direction
    when 'forward'
      horizontal += number
    when 'down'
      depth += number
    when 'up'
      depth -= number
    end
  end

  { depth: depth, horizontal: horizontal }
end

def final_position(commands)
  depth = 0
  horizontal = 0
  aim = 0

  commands.each do |command|
    direction, number = command.split(' ')
    number = number.to_i

    case direction
    when 'forward'
      horizontal += number
      depth += number * aim
    when 'down'
      aim += number
    when 'up'
      aim -= number
    end
  end

  { depth: depth, horizontal: horizontal }
end

if __FILE__ == $PROGRAM_NAME
  require_relative './utils'
  input_array = read_input_file(2, 'string')

  part_a_solution = calculate_position_prototype(input_array)
  part_a_product = part_a_solution.values.reduce(1) { |acc, num| acc * num }
  puts "solution for part A: #{part_a_solution}, their product: #{part_a_product}"

  part_b_solution = final_position(input_array)
  part_b_product = part_b_solution.values.reduce(1) { |acc, num| acc * num }
  puts "solution for part B: #{part_b_solution}, their product: #{part_b_product}"
end
