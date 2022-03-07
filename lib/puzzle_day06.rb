def count_fish(fish_string)
  fish_string.split(',').reduce(Hash.new(0)) do |counter, digit_string|
    digit = digit_string.to_i
    counter[digit] += 1
    counter
  end
end

def next_day(fish_hash)
  new_hash = Hash.new(0)

  fish_hash.each do |fish_timer, count|
    case fish_timer
    when 1..8
      new_hash[fish_timer - 1] += count
    when 0
      new_hash[8] = count
      new_hash[6] += count
    else
      raise KeyError
    end
  end

  new_hash
end

def predict_fish_counts(input_string, days)
  fish_hash = count_fish(input_string)
  days.times do
    fish_hash = next_day(fish_hash)
  end

  fish_hash.values.sum
end

if __FILE__ == $PROGRAM_NAME
  require_relative './utils'
  input_array = read_input_file(6, 'string')
  raise if input_array.length > 1

  input_string = input_array.first
  part_a_solution = predict_fish_counts(input_string, 80)
  puts "solution for part A: #{part_a_solution}"

  part_b_solution = predict_fish_counts(input_string, 256)
  puts "solution for part B: #{part_b_solution}"
end
