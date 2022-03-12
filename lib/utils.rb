def read_input_file(day_number, data_type = 'string')
  dir_path = File.dirname(__FILE__)
  path = File.join(dir_path, "../data/day#{day_number}input.txt")
  array = []
  File.open(path, 'r') do |line|
    array = line.read.split("\n")
  end

  case data_type
  when 'string'
    array
  when 'integer'
    array.map(&:to_i)
  else
    raise NotImplementedError
  end
end

def read_file(filename)
  dir_path = File.dirname(__FILE__)
  path = File.join(dir_path, "../data/#{filename}")
  array = []
  File.open(path, 'r') do |line|
    array = line.read.split("\n")
  end
  array
end

def load_example_file(day_number, key_pattern)
  examples = {}
  curr_example = nil

  read_file("day#{day_number}examples.txt").each do |line|
    case line
    when key_pattern
      curr_example = line.to_i
      examples[curr_example] = []
    when ''
      next
    else
      examples[curr_example] << line
    end
  end

  examples
end
