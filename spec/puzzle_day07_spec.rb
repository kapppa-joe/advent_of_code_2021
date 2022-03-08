require 'puzzle_day07'

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

describe '#parse_input' do
  it 'convert a string of numbers separated by comma into an array of numbers' do
    input = '1101,1,29,67,1102,0,1,65,1008,65,35'
    expected_output = [1101, 1, 29, 67, 1102, 0, 1, 65, 1008, 65, 35]

    expect(parse_input(input)).to eql expected_output
  end
end

describe '#find_optimal_position' do
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

describe '#find_optimal_position_gss' do
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

describe '#find_optimal_position_gss' do
  it 'solve the example case correctly' do
    input = parse_input('16,1,2,0,4,2,7,1,2,14')
    expected_output = {
      optimal_position: 2,
      total_fuel_cost: 37
    }

    expect(find_optimal_position_gss(input)).to eql expected_output
  end
end

describe '#find_optimal_position acceptance test' do
  it 'solve the example case correctly' do
    input = parse_input('16,1,2,0,4,2,7,1,2,14')
    expected_output = {
      optimal_position: 2,
      total_fuel_cost: 37
    }

    expect(find_optimal_position(input)).to eql expected_output
  end
end
