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

    def count_pairs(polymer)
      number_of_pairs = polymer.length - 1
      number_of_pairs.times.each_with_object(Hash.new(0)) do |i, hash|
        pair = polymer[i, 2]
        hash[pair] += 1
      end
    end

    def run_rules_on_pairs(pairs_count)
      new_hash = Hash.new(0)
      pairs_count.each do |pair, count|
        new_pairs = make_new_pairs(pair)
        new_pairs.each { |new_pair| new_hash[new_pair] += count }
      end
      new_hash
    end

    def make_new_pairs(pair)
      return [pair] unless @rules.include?(pair)

      middle_char = @rules[pair]
      left_char, right_char = pair.chars
      [left_char + middle_char, middle_char + right_char]
    end

    def run_rules_on_pairs_n_times(input_pairs, n)
      n.times.reduce(input_pairs) do |pairs_count|
        run_rules_on_pairs(pairs_count)
      end
    end

    def count_occurrence_from_pairs(starting_polymer, pairs_count)
      molecules_count = Hash.new(0)
      pairs_count.each do |pair, count|
        left_char, right_char = pair.chars
        molecules_count[left_char] += count
        molecules_count[right_char] += count
      end

      add_one_to_start_and_end_chars(starting_polymer, molecules_count) if pairs_count.length > 1
      reduce_each_count_to_half(molecules_count)
    end

    def add_one_to_start_and_end_chars(starting_polymer, molecules_count)
      first_char = starting_polymer[0]
      last_char = starting_polymer[-1]
      molecules_count[first_char] += 1
      molecules_count[last_char] += 1
    end

    def reduce_each_count_to_half(molecules_count)
      molecules_count.update(molecules_count) { |_, count| count / 2 }
    end

    # def run_rules(template)
    #   result = ''
    #   template.length.times do |i|
    #     pair = template[i, 2]
    #     result << template[i] + polymer_to_insert_between(pair)
    #   end
    #   result
    # end

    # def run_rules_n_times(template, n)
    #   n.times.reduce(template) do |polymers|
    #     run_rules(polymers)
    #   end
    # end

    # def polymer_to_insert_between(pair)
    #   @rules.include?(pair) ? @rules[pair] : ''
    # end

    def count_molecules(polymer)
      polymer.chars.each_with_object(Hash.new(0)) do |molecule, count|
        count[molecule] += 1
      end
    end

    # def freq_diff_after_n_step(n, verbose: false)
    #   after_n_steps = run_rules_n_times(@starting_template, n)
    #   count_result = count_molecules(after_n_steps)
    #   most_common = count_result.max_by { |k, v| v }
    #   least_common = count_result.min_by { |k, v| v }
    #   return most_common.last - least_common.last unless verbose
    #   puts "
    #     most_common: #{most_common}
    #     least_common: #{least_common}
    #     diff: #{most_common.last - least_common.last}
    #   "
    # end

    def freq_diff_after_n_step_by_pair_counts(n)
      starting_pairs = count_pairs(@starting_template)
      after_n_steps = run_rules_on_pairs_n_times(starting_pairs, n)
      count_result = count_occurrence_from_pairs(@starting_template, after_n_steps)
      most_common = count_result.max_by { |_k, v| v }
      least_common = count_result.min_by { |_k, v| v }

      most_common.last - least_common.last
    end
  end
end


if __FILE__ == $PROGRAM_NAME
  require_relative './utils'
  input_array = read_input_file(14, 'string')
  polymer = Day14::Polymerize.new(input_array)

  part_a_solution = polymer.freq_diff_after_n_step_by_pair_counts(10)
  puts "solution for part A: #{part_a_solution}"

  part_b_solution = polymer.freq_diff_after_n_step_by_pair_counts(40)
  puts "solution for part B: #{part_b_solution}"

  # part_b_instance = Day12::PassagePathingWithSecondVisit.new(input_array)
  # part_b_solution = part_b_instance.search_paths.length
  # puts "solution for part B: #{part_b_solution}"
end
