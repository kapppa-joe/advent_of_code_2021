require 'puzzle_day07'

describe '#parse_input' do
  it 'convert a string of numbers separated by comma into an array of numbers' do
    input = '1101,1,29,67,1102,0,1,65,1008,65,35'
    expected_output = [1101, 1, 29, 67, 1102, 0, 1, 65, 1008, 65, 35]

    expect(parse_input(input)).to eql expected_output
  end
end

describe '#total_cost' do
  it 'return 0 when given an empty array and an integer' do
    crab_positions = []
    align_at = 0
    expected_output = 0

    expect(total_cost(crab_positions, align_at)).to eql expected_output
  end

  it 'return 1 when given crab positions [1] and align at 0' do
    crab_positions = [1]
    align_at = 0
    expected_output = 1

    expect(total_cost(crab_positions, align_at)).to eql expected_output
  end

  it 'return 6 when given crab positions [1, 2, 3] and align at 0' do
    crab_positions = [1, 2, 3]
    align_at = 0
    expected_output = 6

    expect(total_cost(crab_positions, align_at)).to eql expected_output
  end

  it 'return 5 when given crab positions [1, 2, 3] and align at 1' do
    crab_positions = [1, 2, 3]
    align_at = 1
    expected_output = 3

    expect(total_cost(crab_positions, align_at)).to eql expected_output
  end

  it 'return 2 when given crab positions [1, 2, 3] and align at 1' do
    crab_positions = [1, 2, 3]
    align_at = 2
    expected_output = 2

    expect(total_cost(crab_positions, align_at)).to eql expected_output
  end
end

describe '#non_linear_fuel_cost' do
  it 'returns 0 if from = 1 and to = 1' do
    from = 1
    to = 1
    expected_output = 0

    expect(non_linear_fuel_cost(from, to)).to eql expected_output
  end

  it 'returns 1 if from = 1 and to = 2' do
    from = 1
    to = 2
    expected_output = 1

    expect(non_linear_fuel_cost(from, to)).to eql expected_output
  end

  it 'returns 1 if from = 2 and to = 1' do
    from = 2
    to = 1
    expected_output = 1

    expect(non_linear_fuel_cost(from, to)).to eql expected_output
  end

  it 'returns 3 if from = 0 and to = 2' do
    from = 0
    to = 2
    expected_output = 3

    expect(non_linear_fuel_cost(from, to)).to eql expected_output
  end

  describe 'it calculate the fuel costs for example cases correctly' do
    test_cases = {
      [16, 5] => 66,
      [1, 5] => 10,
      [0, 5] => 15,
      [4, 5] => 1,
      [7, 5] => 3,
      [14, 5] => 45
    }

    test_cases.each do |inputs, expected_output|
      it "inputs: #{inputs}, expected_output: #{expected_output}" do
        expect(non_linear_fuel_cost(*inputs)).to eql expected_output
      end
    end
  end
end

describe '#non_linear_total_cost' do
  it 'solve the example case correctly, case for align at 2' do
    crab_positions = parse_input('16,1,2,0,4,2,7,1,2,14')
    align_at = 2
    expected_output = 206

    expect(non_linear_total_cost(crab_positions, align_at)).to eql expected_output
  end

  it 'solve the example case correctly, case for align at 5' do
    crab_positions = parse_input('16,1,2,0,4,2,7,1,2,14')
    align_at = 5
    expected_output = 168

    expect(non_linear_total_cost(crab_positions, align_at)).to eql expected_output
  end
end

describe '#find_optimal_position' do
  context 'fuel cost is linear function' do
    it 'returns 1, 0 if given an array [1]' do
      input = [1]
      expected_output = {
        optimal_position: 1,
        total_fuel_cost: 0
      }

      expect(find_optimal_position(input)).to eql expected_output
    end

    it 'returns 2, 0 if given an array [2, 2, 2]' do
      input = [2]
      expected_output = {
        optimal_position: 2,
        total_fuel_cost: 0
      }
      expect(find_optimal_position(input)).to eql expected_output
    end

    it 'returns 1, 2 if given an array [0, 2]' do
      input = [0, 2]
      expected_output = {
        optimal_position: 0,
        total_fuel_cost: 2
      }
      expect(find_optimal_position(input)).to eql expected_output
    end

    it 'returns 10, 100 if given an array [0, 10, 100]' do
      input = [0, 10, 100]
      expected_output = {
        optimal_position: 10,
        total_fuel_cost: 100
      }
      expect(find_optimal_position(input)).to eql expected_output
    end
  end
end

describe '#find_optimal_position_gss' do
  context 'fuel cost is linear function' do
    it 'returns 1, 0 if given an array [1]' do
      input = [1]
      expected_output = {
        optimal_position: 1,
        total_fuel_cost: 0
      }

      expect(find_optimal_position_gss(input)).to eql expected_output
    end

    it 'returns 2, 0 if given an array [2, 2, 2]' do
      input = [2]
      expected_output = {
        optimal_position: 2,
        total_fuel_cost: 0
      }
      expect(find_optimal_position_gss(input)).to eql expected_output
    end

    it 'returns 1, 2 if given an array [0, 2]' do
      input = [0, 2]
      expected_output = {
        optimal_position: 0,
        total_fuel_cost: 2
      }
      expect(find_optimal_position_gss(input)).to eql expected_output
    end

    it 'returns 10, 100 if given an array [0, 10, 100]' do
      input = [0, 10, 100]
      expected_output = {
        optimal_position: 10,
        total_fuel_cost: 100
      }
      expect(find_optimal_position_gss(input)).to eql expected_output
    end
  end
end

describe '#find_optimal_position_gss acceptance test' do
  context 'when fuel cost is linear function' do
    it 'solve the example case correctly' do
      input = parse_input('16,1,2,0,4,2,7,1,2,14')
      expected_output = {
        optimal_position: 2,
        total_fuel_cost: 37
      }

      expect(find_optimal_position_gss(input)).to eql expected_output
    end
  end

  context 'when fuel cost is non-linear function' do
    it 'solve the example case correctly' do
      input = parse_input('16,1,2,0,4,2,7,1,2,14')
      expected_output = {
        optimal_position: 5,
        total_fuel_cost: 168
      }

      expect(find_optimal_position_gss(input, linear: false)).to eql expected_output
    end
  end
end

describe '#find_optimal_position acceptance test' do
  context 'when fuel cost is linear function' do
    it 'solve the example case correctly' do
      input = parse_input('16,1,2,0,4,2,7,1,2,14')
      expected_output = {
        optimal_position: 2,
        total_fuel_cost: 37
      }

      expect(find_optimal_position(input)).to eql expected_output
    end
  end

  context 'when fuel cost is non-linear function' do
    it 'solve the example case correctly' do
      input = parse_input('16,1,2,0,4,2,7,1,2,14')
      expected_output = {
        optimal_position: 5,
        total_fuel_cost: 168
      }

      expect(find_optimal_position(input, linear: false)).to eql expected_output
    end
  end
end
