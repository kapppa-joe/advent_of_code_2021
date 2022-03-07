
def parse_input(string)
  pattern = /(\d+),(\d+) -> (\d+),(\d+)/
  match = pattern.match(string)
  return [] unless match && match.size == 5

  x1, y1, x2, y2 = match[1..4].map(&:to_i)
  [x1, y1, x2, y2]
end

def horizontal?(vent)
  return false if vent.size < 4

  _, y1, _, y2 = vent
  y1 == y2
end

def vertical?(vent)
  return false if vent.size < 4

  x1, _, x2, _y2 = vent
  x1 == x2
end

def make_diagram
  Hash.new(0)
end

def make_range(n1, n2, length)
  return Array.new(length, n1) if n1 == n2

  n2 > n1 ? (n1..n2).to_a : n1.downto(n2).to_a
end

def update_vent_diagram(diagram, vent)
  x1, y1, x2, y2 = vent

  vent_length = [(x2 - x1).abs, (y2 - y1).abs].max + 1
  x_range = make_range(x1, x2, vent_length)
  y_range = make_range(y1, y2, vent_length)

  x_range.each_with_index do |x, i|
    y = y_range[i]
    diagram[([x, y])] += 1
  end

  diagram
end

def count_overlaps(input_array, count_diagonals: false)
  vents = input_array
          .map { |string| parse_input(string) }
  unless count_diagonals
    vents.filter! { |vent| vertical?(vent) || horizontal?(vent) }
  end

  diagram = make_diagram
  vents.each { |vent| update_vent_diagram(diagram, vent) }

  diagram.values.count { |v| v >= 2 }
end

if __FILE__ == $PROGRAM_NAME
  require_relative './utils'
  input_array = read_input_file(5, 'string')

  part_a_solution = count_overlaps(input_array)
  puts "solution for part A: #{part_a_solution}"

  part_a_solution = count_overlaps(input_array, count_diagonals: true)
  puts "solution for part B: #{part_a_solution}"
end
