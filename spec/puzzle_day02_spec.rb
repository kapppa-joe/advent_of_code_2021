require 'puzzle_day02'

describe '#calculate_position' do
  it 'returns {depth: 0, horizontal: 0} when given an empty array' do
    input = []
    expected_output = { depth: 0, horizontal: 0 }

    expect(calculate_position(input)).to eql expected_output
  end

  it 'returns {depth: 0, horizontal: 1} when given array ["forward 1"]' do
    input = ['forward 1']
    expected_output = { depth: 0, horizontal: 1 }

    expect(calculate_position(input)).to eql expected_output
  end

  it 'returns {depth: 1, horizontal: 0} when given array ["down 1"]' do
    input = ['down 1']
    expected_output = { depth: 1, horizontal: 0 }

    expect(calculate_position(input)).to eql expected_output
  end

  it 'returns {depth: 0, horizontal: 2} when given array ["forward 2"]' do
    input = ['forward 2']
    expected_output = { depth: 0, horizontal: 2 }

    expect(calculate_position(input)).to eql expected_output
  end

  it 'returns {depth: 1, horizontal: 1} when given array ["forward 1", "down 1"]' do
    input = ['forward 1', 'down 1']
    expected_output = { depth: 1, horizontal: 1 }

    expect(calculate_position(input)).to eql expected_output
  end

  it 'returns {depth: 1, horizontal: 1} when given array ["down 1", "forward 1"]' do
    input = ['forward 1', 'down 1']
    expected_output = { depth: 1, horizontal: 1 }

    expect(calculate_position(input)).to eql expected_output
  end

  it 'returns {depth: 0, horizontal: 0} when given array ["down 1", "up 1"]' do
    input = ['down 1', 'up 1']
    expected_output = { depth: 0, horizontal: 0 }

    expect(calculate_position(input)).to eql expected_output
  end

  it "returns {depth: 3, horizontal: 0} when given array ['down 1', 'down 2]" do
    input = ['down 1', 'down 1']
    expected_output = { depth: 2, horizontal: 0 }

    expect(calculate_position(input)).to eql expected_output
  end

  describe 'can handle longer commands correctly' do
    test_cases = [
      [['down 7', 'down 5', 'down 7', 'down 0'], { horizontal: 0, depth: 19 }],
      [['down 8', 'up 0', 'up 7', 'down 8', 'up 0'], { horizontal: 0, depth: 9 }],
      [['down 5', 'up 3', 'forward 3', 'down 8'], { horizontal: 3, depth: 10 }],
      [['down 0', 'down 6', 'down 9', 'up 9', 'up 4', 'down 3'], { horizontal: 0, depth: 5 }],
      [['forward 2', 'down 4', 'forward 8', 'forward 4', 'down 7', 'forward 1'], { horizontal: 15, depth: 11 }],
      [['forward 9', 'down 5', 'up 2', 'down 7', 'down 6', 'down 3'], { horizontal: 9, depth: 19 }]
    ]
    test_cases.each do |input, expected_output|
      it "returns #{expected_output} when given #{input}" do
        expect(calculate_position(input)).to eql expected_output
      end
    end
  end
end

describe '#calculate_position acceptance test' do
  it 'solves the example case correctly' do
    input = [
      'forward 5',
      'down 5',
      'forward 8',
      'up 3',
      'down 8',
      'forward 2'
    ]
    expected_output = { horizontal: 15, depth: 10 }

    expect(calculate_position(input)).to eql expected_output
  end
end
