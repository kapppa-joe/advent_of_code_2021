require 'puzzle_day01'

describe '#count_depth_increase' do
  it 'returns 0 when given an empty array' do
    input = []
    expected_output = 0

    expect(count_depth_increase(input)).to eql expected_output
  end

  it 'returns 0 when given an array with length = 1' do
    input = [100]
    expected_output = 0

    expect(count_depth_increase(input)).to eql expected_output
  end

  it 'return 1 when given an array [0, 1]' do
    input = [0, 1]
    expected_output = 1

    expect(count_depth_increase(input)).to eql expected_output
  end

  it 'return 0 when given an array [0, 0]' do
    input = [0, 0]
    expected_output = 0

    expect(count_depth_increase(input)).to eql expected_output
  end

  it 'returns 2 when given an array [0, 1, 2]' do
    input = [0, 1, 2]
    expected_output = 2

    expect(count_depth_increase(input)).to eql expected_output
  end
end

describe '#count_depth_increase acceptance test' do
  it 'solves the example case correctly' do
    input = %i[199 200 208 210 200 207 240 269 260 263]
    expected_output = 7

    expect(count_depth_increase(input)).to eql expected_output
  end
end
