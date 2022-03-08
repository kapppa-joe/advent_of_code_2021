require 'puzzle_day03'

describe '#analyse_diagnostic_report' do
  it 'solve the example correctly' do
    input = %w[00100 11110 10110 10111 10101 01111
               00111 11100 10000 11001 00010 01010]

    expected_output = {
      gamma_rate: 22,
      epsilon_rate: 9,
      power_consumption: 198
    }

    expect(analyse_diagnostic_report(input)).to eql expected_output
  end
end

describe 'find_epsilon_rate' do
  it 'return 0 when given 0b01 and 1' do
    gamma_rate = 0b01
    binary_length = 1
    expected_output = 0

    expect(find_epsilon_rate(gamma_rate, binary_length)).to eql expected_output
  end

  it 'return 1 when given 0b00 and 1' do
    gamma_rate = 0b00
    binary_length = 1
    expected_output = 1

    expect(find_epsilon_rate(gamma_rate, binary_length)).to eql expected_output
  end

  it 'return 0b11 when given 0b00 and 2' do
    gamma_rate = 0b00
    binary_length = 2
    expected_output = 0b11

    expect(find_epsilon_rate(gamma_rate, binary_length)).to eql expected_output
  end

  describe 'return the inverted bit of gamma rate with length binary_length' do
    test_cases = [
      [[0b0011, 4], 0b1100],
      [[0b0011, 6], 0b111100],
      [[0b10100101, 8], 0b01011010]
    ]
    test_cases.each do |input_values, expected_output|
      gamma_rate, binary_length = input_values
      it "gamma_rate:#{gamma_rate}, binary_length: #{binary_length}, expected_output: #{expected_output}" do
        expect(find_epsilon_rate(gamma_rate, binary_length)).to eql expected_output
      end
    end
  end
end

describe '#most_frequent_bits' do
  it 'returns "00100" if given array ["00100"]' do
    input = ['00100']
    expected_output = '00100'

    expect(most_frequent_bits(input)).to eql expected_output
  end

  it 'returns "11110" if given array ["11110"]' do
    input = ['11110']
    expected_output = '11110'

    expect(most_frequent_bits(input)).to eql expected_output
  end

  it 'returns "10110" if given array %w[00100 11110 10110]' do
    input = %w[00100 11110 10110]
    expected_output = '10110'

    expect(most_frequent_bits(input)).to eql expected_output
  end

  it 'returns a string made up of the most frequent bits at each position' do
    input = %w[00100 11110 10110 10111 10101 01111
               00111 11100 10000 11001 00010 01010]
    expected_output = '10110'

    expect(most_frequent_bits(input)).to eql expected_output
  end
end

describe '#most_frequent_single_bit' do
  it 'return nil when given an empty array' do
    input = []
    expected_output = nil

    expect(most_frequent_single_bit(input)).to eql expected_output
  end

  it "returns '0' when given array ['0']" do
    input = ['0']
    expected_output = '0'

    expect(most_frequent_single_bit(input)).to eql expected_output
  end

  it "returns '1' when given array ['1']" do
    input = ['1']
    expected_output = '1'

    expect(most_frequent_single_bit(input)).to eql expected_output
  end

  it "returns '1' when given array ['0', '1']" do
    input = %w[0 1]
    expected_output = '1'

    expect(most_frequent_single_bit(input)).to eql expected_output
  end

  describe 'returns the more frequent bit in the array' do
    test_cases = [
      [%w[1 0 1 0 1], '1'],
      [%w[1 0 1 0 0], '0'],
      [%w[0 1 0 1 0 1 1], '1'],
      [%w[0 1 0 1 0 1 0], '0'],
      [%w[1 1 0 1 0 1 1], '1']
    ]
    test_cases.each do |input, expected_output|
      it "input: #{input}, expected output: #{expected_output}" do
        expect(most_frequent_single_bit(input)).to eql expected_output
      end
    end
  end

  describe 'return 1 when having same number of 0s and 1s' do
    test_cases = [
      [%w[1 0 1 0], '1'],
      [%w[0 1 0 1 0 1], '1'],
      [%w[0 0 0 0 1 1 1 1], '1']
    ]
    test_cases.each do |input, expected_output|
      it "input: #{input}, expected output: #{expected_output}" do
        expect(most_frequent_single_bit(input)).to eql expected_output
      end
    end
  end
end

describe '#find_life_support_rating' do
  it 'solve the example correctly' do
    input = %w[00100 11110 10110 10111 10101 01111
               00111 11100 10000 11001 00010 01010]
    expected_output = {
      oxygen_generator_rating: 23,
      co2_scrubber_rating: 10,
      life_support_rating: 230
    }

    expect(find_life_support_rating(input)).to eq expected_output
  end
end

describe '#find_oxygen_generator_rating' do
  it 'solve the example correctly' do
    input = %w[00100 11110 10110 10111 10101 01111
               00111 11100 10000 11001 00010 01010]
    expected_output = 23

    expect(find_oxygen_generator_rating(input)).to eq expected_output
  end
end

describe '#find_co2_scrubber_rating' do
  it 'solve the example correctly' do
    input = %w[00100 11110 10110 10111 10101 01111
               00111 11100 10000 11001 00010 01010]
    expected_output = 10

    expect(find_co2_scrubber_rating(input)).to eq expected_output
  end
end

describe '#repeated_filter' do
  it 'returns the only element if given an array with length of 1' do
    input = ['1']
    expected_output = '1'

    expect(repeated_filter(input)).to eql expected_output

    input = ['0']
    expected_output = '0'

    expect(repeated_filter(input)).to eql expected_output
  end

  context 'when no block is given' do
    it "returns '10' if given an array of %w[01 10]" do
      input = %w[01 10]
      expected_output = '10'

      expect(repeated_filter(input)).to eql expected_output
    end

    it "returns '11' if given an array of %w[10 01 11]" do
      input = %w[10 01 11]
      expected_output = '11'

      expect(repeated_filter(input)).to eql expected_output
    end

    describe 'filters the input array repeatedly with most frequent bit, and return the last remaining element' do
      test_cases = [
        [%w[11101 00010 11100 01100 11110 11011 01001 10100 00000 00110], '11101'],
        [%w[00111 01010 01100 01101 10000 00000 10001 10111 10000 01101], '01101']
      ]
      test_cases.each do |input, expected_output|
        it "input: #{input}, expected output: #{expected_output}" do
          expect(repeated_filter(input)).to eql expected_output
        end
      end
    end
  end

  context 'when given a block to find least frequent bit' do
    let(:block) do
      lambda do |current_bits|
        most_freq_bit = most_frequent_single_bit(current_bits)
        most_freq_bit == '1' ? '0' : '1'
      end
    end

    it "returns '0' when given array %w[1 0]" do
      input = %w[1 0]
      expected_output = '0'
      expect(repeated_filter(input, &block)).to eql expected_output
    end

    it "returns '01' if given an array of %w[01 10]" do
      input = %w[01 10]
      expected_output = '01'

      expect(repeated_filter(input, &block)).to eql expected_output
    end

    describe 'filters the input array repeatedly with least frequent bit, and return the last remaining element' do
      test_cases = [
        [%w[101 011 110 001], '001'],
        [%w[0101 0110 0011 1011 0000], '1011'],
        [%w[10101 00100 01010 11010 01011], '10101']
      ]
      test_cases.each do |input, expected_output|
        it "input: #{input}, expected output: #{expected_output}" do
          expect(repeated_filter(input, &block)).to eql expected_output
        end
      end
    end
  end
end
