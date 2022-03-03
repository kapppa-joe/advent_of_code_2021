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
