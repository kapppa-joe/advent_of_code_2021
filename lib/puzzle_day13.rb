module Day13
  class Origami
    def parse_input(input_array)
      dots = []
      folding_instruction = []

      input_array.each do |line|
        case line
        when /\d+,\d+/
          dots << line.split(',').map(&:to_i)
        when /fold along [xy]=\d+/
          label, index = line.split(' ').last.split('=')
          folding_instruction << [label.to_sym, index.to_i]
        when ''
          next
        else
          raise RuntimeError
        end
      end

      { dots: dots, folding_instruction: folding_instruction }
    end

    def fold_paper(dots, axis, line)
      dots.map do |dot|
        new_position(dot, axis, line)
      end.uniq.compact
    end

    def repeat_fold(initial_dots, folding_instruction)
      folding_instruction.reduce(initial_dots) do |dots, fold_inst|
        fold_paper(dots, *fold_inst)
      end
    end

    def new_position(dot, axis, line)
      return nil if dot_on_the_folding_line?(dot, axis, line)

      x, y = dot
      if axis == :x && x > line
        [mirror_position(x, line), y]
      elsif axis == :y && y > line
        [x, mirror_position(y, line)]
      else
        [x, y]
      end
    end

    def dot_on_the_folding_line?(dot, axis, line)
      x, y = dot
      (axis == :x && x == line) || (axis == :y && y == line)
    end

    def mirror_position(position, line)
      line * 2 - position
    end

    def plot_dots(dots)
      paper = make_blank_paper(height(dots), width(dots))
      dots.each do |x, y|
        paper[y][x] = '*'
      end
      paper.join("\n")
    end

    def width(dots)
      dots.map { |x, _y| x }.max + 1
    end

    def height(dots)
      dots.map { |_x, y| y }.max + 1
    end

    def make_blank_paper(height, width)
      Array.new(height) { ' ' * width }
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  require_relative './utils'
  input_array = read_input_file(13, 'string')
  origami = Day13::Origami.new

  inputs = origami.parse_input(input_array)
  dots = inputs[:dots]
  folding_instruction = inputs[:folding_instruction]

  part_a_solution = origami.fold_paper(dots, *folding_instruction[0]).length
  puts "solution for part A: #{part_a_solution}"

  dots_after_folding = origami.repeat_fold(dots, folding_instruction)
  part_b_solution = origami.plot_dots(dots_after_folding)
  puts "solution for part B: \n#{part_b_solution}"
end
