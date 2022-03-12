require 'puzzle_day11'
require 'utils'

module ExampleInputForDay11
  BasicExampleStep0 = %w[11111
                         19991
                         19191
                         19991
                         11111]

  BasicExampleStep1 = %w[34543
                         40004
                         50005
                         40004
                         34543]

  BasicExampleStep2 = %w[45654
                         51115
                         61116
                         51115
                         45654]

  LargerExamples = load_example_file(11, /\d+:/)

end

describe Day11::DumboOctopus do
  let(:dumbo) { described_class.new(ExampleInputForDay11::BasicExampleStep0) }
  describe '#parse_input' do
    it 'convert the input into a hash of x,y coordinate to energy level' do
      input = %w[12 34]
      expected_output = {
        [0, 0] => 1,
        [1, 0] => 2,
        [0, 1] => 3,
        [1, 1] => 4
      }

      expect(dumbo.parse_input(input)).to eql expected_output
    end
  end

  describe '#each_neighbour_of' do
    describe 'returns the coordinates of surrounding cells of given coordinate' do
      it 'case of (0, 0)' do
        input = [0, 0]
        expected_output = [[0, 1], [1, 0], [1, 1]]
        expect(dumbo.each_neighbour_of(*input)).to match_array expected_output
      end

      it 'case of (0, 1)' do
        input = [0, 1]
        expected_output = [[1, 1], [1, 2], [0, 2], [0, 0], [1, 0]]

        expect(dumbo.each_neighbour_of(*input)).to match_array expected_output
      end

      it 'case of (1, 1)' do
        input = [1, 1]
        expected_output = [[2, 1], [2, 2], [1, 2], [0, 2], [0, 1], [0, 0], [1, 0], [2, 0]]

        expect(dumbo.each_neighbour_of(*input)).to match_array expected_output
      end

      it 'case of bottom_right edge' do
        input = [4, 4]
        expected_output = [[3, 4], [3, 3], [4, 3]]

        expect(dumbo.each_neighbour_of(*input)).to match_array expected_output
      end
    end

    it 'yield the returned coordinates if a block was given' do
      input = [1, 1]
      expected_yield_args = [[0, 0], [0, 1], [0, 2], [1, 0], [1, 2], [2, 0], [2, 1], [2, 2]]
      expect do |block|
        dumbo.each_neighbour_of(*input, &block)
      end.to yield_successive_args(*expected_yield_args)
    end

    it 'raise index error if given coordinate is invalid' do
      expect { dumbo.each_neighbour_of(-1, 0) }.to raise_error(IndexError)
      expect { dumbo.each_neighbour_of(1, -1) }.to raise_error(IndexError)
      expect { dumbo.each_neighbour_of(2, 5) }.to raise_error(IndexError)
    end
  end

  describe '#increase_energy_for_all' do
    it 'increase the energy of all octopus by 1' do
      octopus_before = dumbo.octopus.clone
      dumbo.increase_energy_for_all
      dumbo.octopus.each do |coord, new_energy_level|
        old_energy_level = octopus_before[coord]
        expect(new_energy_level).to eql old_energy_level + 1
      end
    end
  end

  describe '#energy_level_over_9' do
    it 'return an empty array if no octopus has energy level > 9' do
      expect(dumbo.energy_level_over_9).to eql []
    end

    it 'return the coordinates of all octopus with energy level > 9' do
      expected_output = [
        [1, 1], [2, 1], [3, 1],
        [1, 2], [3, 2],
        [1, 3], [2, 3], [3, 3]
      ]

      dumbo.increase_energy_for_all
      expect(dumbo.energy_level_over_9).to match_array expected_output
    end
  end

  describe '#flash_at' do
    let(:dumbo) do
      described_class.new(%w[000 000 000])
    end

    it 'increase the energy level of all surrounding cells by 1' do
      input_map = %w[123 456 789]
      input_coordinates = [[0, 0]]
      expected_output = %w[133 566 789]

      dumbo = described_class.new(input_map)
      dumbo.flash_at(input_coordinates)

      expect(dumbo.octopus).to eql dumbo.parse_input(expected_output)
    end

    it 'can handle the flash of multiple coordinates with overlapping neighbours correctly' do
      input_coordinates = [[0, 0], [1, 1], [2, 2]]
      expected_output = %w[121 222 121]
      dumbo.flash_at(input_coordinates)

      expect(dumbo.octopus).to eql dumbo.parse_input(expected_output)
    end
  end

  describe '#next_turn acceptance test' do
    context 'basic example' do
      let(:dumbo) { described_class.new(ExampleInputForDay11::BasicExampleStep0) }
      it 'solve the 1st turn of basic input correctly' do
        input = ExampleInputForDay11::BasicExampleStep0
        expected_octopus_after_turn = dumbo.parse_input(ExampleInputForDay11::BasicExampleStep1)
        expected_flash_count = 9

        dumbo = described_class.new(input)
        result = dumbo.next_turn

        expect(dumbo.octopus).to eql expected_octopus_after_turn
        expect(result[:flash_count]).to eql expected_flash_count
      end

      it 'solve the 2nd turn of basic input correctly' do
        input = ExampleInputForDay11::BasicExampleStep1
        expected_octopus_after_turn = dumbo.parse_input(ExampleInputForDay11::BasicExampleStep2)
        expected_flash_count = 0

        dumbo = described_class.new(input)
        result = dumbo.next_turn

        expect(dumbo.octopus).to eql expected_octopus_after_turn
        expect(result[:flash_count]).to eql expected_flash_count
      end
    end

    context 'larger examples' do
      describe 'solves the larger examples correctly' do
        test_cases = ExampleInputForDay11::LargerExamples.clone
        day0 = test_cases[0]
        let(:dumbo) { described_class.new(day0) }

        test_cases.delete(0)
        test_cases.each do |day, expected_octopus|
          it "case: day #{day}" do
            expected_octopus_after_turn = dumbo.parse_input(expected_octopus)
            day.times { dumbo.next_turn }

            expect(dumbo.octopus).to eql expected_octopus_after_turn

            if day == 100
              expect(dumbo.total_flash_count).to eql 1656
            end
          end
        end
      end
    end
  end

  describe '#next_sync_flash' do
    it 'return the turn that all octopus flash simultaneously' do
      input = ExampleInputForDay11::LargerExamples[0]
      expected_output = 195

      dumbo = described_class.new(input)
      expect(dumbo.next_sync_flash).to eql expected_output
    end
  end
end
