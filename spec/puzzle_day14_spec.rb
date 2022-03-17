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
    'CN -> C',
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

  describe '#to_pair_count' do
    it 'count the occurrence of each pair combination in polymer string'
  end

  describe '#run_rules' do

    it 'return empty string if given empty string' do
      input = ''
      expected_output = ''
      expect(polymer.run_rules(input)).to eql expected_output
    end

    it 'return NCN if given template NN and rules "NN -> C"' do
      input_array = [
        '',
        '',
        'NN -> C'
      ]

      input = 'NN'
      expected_output = 'NCN'

      polymer = described_class.new(input_array)
      expect(polymer.run_rules(input)).to eql expected_output
    end

    describe 'solves the first few steps of example case correctly' do
      example_cases = {
        0 => 'NNCB',
        1 => 'NCNBCHB',
        2 => 'NBCCNBBBCBHCB',
        3 => 'NBBBCNCCNBBNBNBBCHBHHBCHB',
        4 => 'NBBNBNBBCCNBCNCCNBBNBBNBBBNBBNBBCBHCBHHNHCBBCBHCB'
      }
      4.times do |i|
        it "step #{i + 1}" do
          input = example_cases[i]
          expected_output = example_cases[i + 1]

          expect(polymer.run_rules(input)).to eql expected_output
        end
      end
    end
  end

  describe '#run_rules_n_times' do
    it 'insert polymer into the template repeatedly for n times' do
      input = 'NNCB'
      n = 4
      expected_output = 'NBBNBNBBCCNBCNCCNBBNBBNBBBNBBNBBCBHCBHHNHCBBCBHCB'

      expect(polymer.run_rules_n_times(input, n)).to eql expected_output
    end

    describe 'it produces result matching the known facts about example cases ' do
      it 'after step 5, it has length 97' do
        input = 'NNCB'
        n = 5
        expected_length = 97

        actual_output = polymer.run_rules_n_times(input, n)
        expect(actual_output.length).to eql expected_length
      end

      it 'after step 10, it has length 3073, and the count of each type of polymer match given numbers' do
        input = 'NNCB'
        n = 10
        expected_length = 3073
        expected_occurrence = {
          'B' => 1749,
          'C' => 298,
          'H' => 161,
          'N' => 865
        }

        actual_output = polymer.run_rules_n_times(input, n)
        expect(actual_output.length).to eql expected_length
        expected_occurrence.each do |molecule, number|
          expect(actual_output.count(molecule)).to eql number
        end
      end
    end
  end

  describe '#freq_diff_after_n_step' do
    it 'solves the example case correctly for n = 10' do
      n = 10
      expect(polymer.freq_diff_after_n_step(n)).to eql 1588
    end

    xit 'solves the example case correctly for n = 40' do
      n = 40
      expect(polymer.freq_diff_after_n_step(n)).to eql 2188189693529
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
