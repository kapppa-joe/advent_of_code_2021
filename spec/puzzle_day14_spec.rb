require 'puzzle_day14'

describe Day14::Polymerize do
  day_14_example = [
    'NNCB',
    'CH -> B',
    'HH -> N',
    'CB -> H',
    'NH -> C',
    'HB -> C',
    'HC -> B',
    'HN -> C',
    'NN -> C',
    'BH -> H',
    'NC -> B',
    'NB -> B',
    'BN -> B',
    'BB -> N',
    'BC -> B',
    'CC -> N',
    'CN -> C'
  ]

  describe '::parse_input' do
    it 'parse the input string array into polymer template and insertion rules' do
      input = day_14_example
      expected_output = {
        template: 'NNCB',
        rules: {
          'CH' => 'B',
          'HH' => 'N',
          'CB' => 'H',
          'NH' => 'C',
          'HB' => 'C',
          'HC' => 'B',
          'HN' => 'C',
          'NN' => 'C',
          'BH' => 'H',
          'NC' => 'B',
          'NB' => 'B',
          'BN' => 'B',
          'BB' => 'N',
          'BC' => 'B',
          'CC' => 'N',
          'CN' => 'C'
        }
      }
      expect(described_class.parse_input(input)).to eql expected_output
    end
  end

  let(:polymer) { described_class.new(day_14_example) }

  describe '#count_pairs' do
    it 'count the occurrence of each pair combination in polymer string' do
      input = 'NNCB'
      expected_output = {
        'NN' => 1,
        'NC' => 1,
        'CB' => 1
      }

      expect(polymer.count_pairs(input)).to eql expected_output
    end

    it 'counts multiple occurrence of same pair correctly' do
      input = 'NBBBCNCCNBBNBNBBCHBHHBCHB'
      expected_output =
        { 'NB' => 4, 'BB' => 4, 'BC' => 3, 'CN' => 2, 'NC' => 1,
          'CC' => 1, 'BN' => 2, 'CH' => 2, 'HB' => 3, 'BH' => 1,
          'HH' => 1 }

      expect(polymer.count_pairs(input)).to eql expected_output
    end
  end

  describe '#run_rules_on_pairs' do
    it 'return the input if no rules match the input pairs' do
      polymer = described_class.new(['AB', 'NN -> C'])
      input = { 'AB' => 1 }
      expected_output = { 'AB' => 1 }

      expect(polymer.run_rules_on_pairs(input)).to eql expected_output
    end

    it 'return {NC => 1, CN => 1} if given { NN => 1} and rule NN -> C' do
      polymer = described_class.new(['NN', 'NN -> C'])
      input = polymer.count_pairs('NN')
      expected_output = { 'NC' => 1, 'CN' => 1 }

      expect(polymer.run_rules_on_pairs(input)).to eql expected_output
    end

    describe 'it solve the first few steps of example case correctly' do
      example_cases = {
        0 => 'NNCB',
        1 => 'NCNBCHB',
        2 => 'NBCCNBBBCBHCB',
        3 => 'NBBBCNCCNBBNBNBBCHBHHBCHB',
        4 => 'NBBNBNBBCCNBCNCCNBBNBBNBBBNBBNBBCBHCBHHNHCBBCBHCB'
      }
      4.times do |i|
        it "step #{i + 1}" do
          input = polymer.count_pairs(example_cases[i])
          expected_output = polymer.count_pairs(example_cases[i + 1])

          expect(polymer.run_rules_on_pairs(input)).to eql expected_output
        end
      end
 
    end
  end

  describe '#run_rules_on_pairs_n_times' do
    it 'insert polymer into the template repeatedly for n times' do
      input = polymer.count_pairs('NNCB')
      n = 4
      expected_output = polymer.count_pairs('NBBNBNBBCCNBCNCCNBBNBBNBBBNBBNBBCBHCBHHNHCBBCBHCB')

      expect(polymer.run_rules_on_pairs_n_times(input, n)).to eql expected_output
    end
  end

  # describe '#run_rules' do
  #   it 'return empty string if given empty string' do
  #     input = ''
  #     expected_output = ''
  #     expect(polymer.run_rules(input)).to eql expected_output
  #   end

  #   it 'return NCN if given template NN and rules "NN -> C"' do
  #     input_array = [
  #       '',
  #       '',
  #       'NN -> C'
  #     ]

  #     input = 'NN'
  #     expected_output = 'NCN'

  #     polymer = described_class.new(input_array)
  #     expect(polymer.run_rules(input)).to eql expected_output
  #   end

  #   describe 'solves the first few steps of example case correctly' do
  #     example_cases = {
  #       0 => 'NNCB',
  #       1 => 'NCNBCHB',
  #       2 => 'NBCCNBBBCBHCB',
  #       3 => 'NBBBCNCCNBBNBNBBCHBHHBCHB',
  #       4 => 'NBBNBNBBCCNBCNCCNBBNBBNBBBNBBNBBCBHCBHHNHCBBCBHCB'
  #     }
  #     4.times do |i|
  #       it "step #{i + 1}" do
  #         input = example_cases[i]
  #         expected_output = example_cases[i + 1]

  #         expect(polymer.run_rules(input)).to eql expected_output
  #       end
  #     end
  #   end
  # end

  describe '#count_occurrence_from_pairs' do
    it 'returns the correct count for basic case of "NNCB"' do
      starting_polymer = "NNCB"
      pairs_count = polymer.count_pairs(starting_polymer)
      expected_output = {
        'N' => 2,
        'C' => 1,
        'B' => 1
      }

      actual_output = polymer.count_occurrence_from_pairs(
        starting_polymer, pairs_count
      )

      expect(actual_output).to eql expected_output
    end

    describe 'returns the correct count for more complex cases' do
      make_random_string = -> { ('A'..'H').map { |char| char * rand(20) }.join.chars.shuffle.join }

      test_strings = ['NBBNBNBBCCNBCNCCNBBNBBNBBBNBBNBBCBHCBHHNHCBBCBHCB']
      5.times { test_strings << make_random_string.call }

      test_strings.each do |test_string|
        it "test_string: #{test_string}" do
          input = polymer.count_pairs(test_string)
          actual_output = polymer.count_occurrence_from_pairs(
            test_string, input
          )

          expect(actual_output).to be_a(Hash)
          actual_output.each do |key, value|
            expect(test_string.count(key)).to eql value
          end
        end
      end
    end
  end

  # describe '#run_rules_n_times' do
  #   it 'insert polymer into the template repeatedly for n times' do
  #     input = 'NNCB'
  #     n = 4
  #     expected_output = 'NBBNBNBBCCNBCNCCNBBNBBNBBBNBBNBBCBHCBHHNHCBBCBHCB'

  #     expect(polymer.run_rules_n_times(input, n)).to eql expected_output
  #   end

  #   describe 'it produces result matching the known facts about example cases ' do
  #     it 'after step 5, it has length 97' do
  #       input = 'NNCB'
  #       n = 5
  #       expected_length = 97

  #       actual_output = polymer.run_rules_n_times(input, n)
  #       expect(actual_output.length).to eql expected_length
  #     end

  #     it 'after step 10, it has length 3073, and the count of each type of polymer match given numbers' do
  #       input = 'NNCB'
  #       n = 10
  #       expected_length = 3073
  #       expected_occurrence = {
  #         'B' => 1749,
  #         'C' => 298,
  #         'H' => 161,
  #         'N' => 865
  #       }

  #       actual_output = polymer.run_rules_n_times(input, n)
  #       expect(actual_output.length).to eql expected_length
  #       expected_occurrence.each do |molecule, number|
  #         expect(actual_output.count(molecule)).to eql number
  #       end
  #     end
  #   end
  # end

  # describe '#freq_diff_after_n_step' do
  #   it 'solves the example case correctly for n = 10' do
  #     n = 10
  #     expect(polymer.freq_diff_after_n_step(n)).to eql 1588
  #   end
  # end

  describe '#freq_diff_after_n_step_by_pair_counts' do
    it 'solves the example case correctly for n = 10' do
      n = 10
      expect(polymer.freq_diff_after_n_step_by_pair_counts(n)).to eql 1588
    end

    it 'solves the example case correctly for n = 40' do
      n = 40
      expect(polymer.freq_diff_after_n_step_by_pair_counts(n)).to eql 2_188_189_693_529
    end
  end

  describe '#count_molecules' do
    it 'return each type of molecule and their counts in a hash' do
      input = 'AABBBCCCCDDDDD'.chars.shuffle.join
      expected_output = {
        'A' => 2,
        'B' => 3,
        'C' => 4,
        'D' => 5
      }
      expect(polymer.count_molecules(input)).to eql expected_output
    end
  end
end
