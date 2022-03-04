require 'puzzle_day03'

# ======================================
#                PART A
# ======================================

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

describe 'calculate_epsilon_rate' do
  it 'return 0 when given 0b01 and 1' do
    gamma_rate = 0b01
    binary_length = 1
    expected_output = 0

    expect(calculate_epsilon_rate(gamma_rate, binary_length)).to eql expected_output
  end

  it 'return 1 when given 0b00 and 1' do
    gamma_rate = 0b00
    binary_length = 1
    expected_output = 1

    expect(calculate_epsilon_rate(gamma_rate, binary_length)).to eql expected_output
  end

  it 'return 0b11 when given 0b00 and 2' do
    gamma_rate = 0b00
    binary_length = 2
    expected_output = 0b11

    expect(calculate_epsilon_rate(gamma_rate, binary_length)).to eql expected_output
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
        expect(calculate_epsilon_rate(gamma_rate, binary_length)).to eql expected_output
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

describe '#find_mode' do
  it 'return nil if given an empty array' do
    expect(find_mode([])).to eql nil
  end

  it 'return 1 if given array [1]' do
    input = [1]
    expected_output = 1

    expect(find_mode(input)).to eql expected_output
  end

  it 'return 2 if given array [2]' do
    input = [2]
    expected_output = 2

    expect(find_mode(input)).to eql expected_output
  end

  it 'return 2 if given array [1, 2, 2]' do
    input = [1, 2, 2]
    expected_output = 2

    expect(find_mode(input)).to eql expected_output
  end

  it 'return 1 if given array [2, 2, 1]' do
    input = [2, 2, 1]
    expected_output = 2

    expect(find_mode(input)).to eql expected_output
  end

  it 'return the mode (most frequent element) in an array' do
    input = [3, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 3, 2, 2, 1]
    expected_output = 1

    expect(find_mode(input)).to eql expected_output
  end
end

# ======================================
#                PART B
# ======================================

xdescribe '#find_life_support_rating' do
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
