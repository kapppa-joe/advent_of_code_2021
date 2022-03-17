module Day14
  class Polymerize
    def initialize(input_array)
      inputs = self.class.parse_input(input_array)
      @rules = inputs[:rules]
      @starting_template = inputs[:template]
    end

    def self.parse_input(input_array)
      template = input_array[0]

      rules_in_array = input_array[1..].map do |line|
        case line
        when /[A-Z]+ -> [A-Z]+/
          line.split(' -> ')
        end
      end

      rules = rules_in_array.compact.to_h
      { template: template, rules: rules }
    end

    def run_rules(template)
      result = ''
      template.length.times do |i|
        pair = template[i, 2]
        result << template[i] + polymer_to_insert_between(pair)
      end
      result
    end

    def run_rules_n_times(template, n)
      n.times.reduce(template) do |polymers|
        run_rules(polymers)
      end
    end

    def polymer_to_insert_between(pair)
      @rules.include?(pair) ? @rules[pair] : ''
    end

    def count_molecules(polymer)
      polymer.chars.each_with_object(Hash.new(0)) do |molecule, count|
        count[molecule] += 1
      end
    end

    def freq_diff_after_n_step(n, verbose: false)
      after_10_steps = run_rules_n_times(@starting_template, n)
      count_result = count_molecules(after_10_steps)
      most_common = count_result.max_by { |k, v| v }
      least_common = count_result.min_by { |k, v| v }
      return most_common.last - least_common.last unless verbose
      puts "
        most_common: #{most_common}
        least_common: #{least_common}
        diff: #{most_common.last - least_common.last}
      "
    end
  end
end


if __FILE__ == $PROGRAM_NAME
  require_relative './utils'
  input_array = read_input_file(14, 'string')
  polymer = Day14::Polymerize.new(input_array)

  part_a_solution = polymer.freq_diff_after_n_step(10)
  puts "solution for part A: #{part_a_solution}"

  after_n_step = polymer.run_rules_n_times(input_array[0], 10)
  puts after_n_step

  # part_b_instance = Day12::PassagePathingWithSecondVisit.new(input_array)
  # part_b_solution = part_b_instance.search_paths.length
  # puts "solution for part B: #{part_b_solution}"
end
