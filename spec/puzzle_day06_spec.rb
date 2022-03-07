require 'puzzle_day06'

describe '#count_fish' do
  it 'return an empty hash {} if given an empty string ""' do
    input = ''
    expected_output = {}

    expect(count_fish(input)).to eql expected_output
  end

  it 'counts how many times each number appears in a given string' do
    input = '3,4,3,1,2'
    expected_output = { 3 => 2, 4 => 1, 1 => 1, 2 => 1 }

    expect(count_fish(input)).to eql expected_output
  end
end

describe '#next_day' do
  it 'reduce the day count of each type of fish' do
    input = count_fish('3,4,3,1,2')
    expected_output = count_fish('2,3,2,0,1')

    expect(next_day(input)).to eql expected_output
  end

  context 'when input contains fish with timer = 0' do
    it 'add a new fish of timer = 8 for each fish of timer 0' do
      input = count_fish('0,1,2,0')
      actual_output = next_day(input)

      expect(actual_output).to include(8 => 2)
    end

    it 'reset the old fish to timer = 6 for each fish of timer 0' do
      input = count_fish('0,1,2,0,7')
      actual_output = next_day(input)

      expect(actual_output).to include(6 => 3)
    end
  end
end

describe '#next_day acceptance test' do
  describe 'it solves the example cases correctly' do
    test_cases = {
      0 => '3,4,3,1,2',
      1 => '2,3,2,0,1',
      2 => '1,2,1,6,0,8',
      3 => '0,1,0,5,6,7,8',
      4 => '6,0,6,4,5,6,7,8,8',
      5 => '5,6,5,3,4,5,6,7,7,8',
      6 => '4,5,4,2,3,4,5,6,6,7',
      7 => '3,4,3,1,2,3,4,5,5,6',
      8 => '2,3,2,0,1,2,3,4,4,5',
      9 => '1,2,1,6,0,1,2,3,3,4,8',
      10 => '0,1,0,5,6,0,1,2,2,3,7,8',
      11 => '6,0,6,4,5,6,0,1,1,2,6,7,8,8,8',
      12 => '5,6,5,3,4,5,6,0,0,1,5,6,7,7,7,8,8',
      13 => '4,5,4,2,3,4,5,6,6,0,4,5,6,6,6,7,7,8,8',
      14 => '3,4,3,1,2,3,4,5,5,6,3,4,5,5,5,6,6,7,7,8',
      15 => '2,3,2,0,1,2,3,4,4,5,2,3,4,4,4,5,5,6,6,7',
      16 => '1,2,1,6,0,1,2,3,3,4,1,2,3,3,3,4,4,5,5,6,8',
      17 => '0,1,0,5,6,0,1,2,2,3,0,1,2,2,2,3,3,4,4,5,7,8',
      18 => '6,0,6,4,5,6,0,1,1,2,6,0,1,1,1,2,2,3,3,4,6,7,8,8,8,8'
    }

    18.times do |day|
      input = count_fish(test_cases[day])
      expected_output = count_fish(test_cases[day + 1])

      it "day #{day}, input: #{input}" do
        expect(next_day(input)).to eql expected_output
      end
    end
  end
end

describe '#predict_fish_counts' do
  it 'can solve the example correctly (after 18 days)' do
    input_string = '3,4,3,1,2'
    input_days = 18
    expected_output = 26

    expect(predict_fish_counts(input_string, input_days)).to eql expected_output
  end

  it 'can solve the example correctly (after 80 days)' do
    input_string = '3,4,3,1,2'
    input_days = 80
    expected_output = 5934

    expect(predict_fish_counts(input_string, input_days)).to eql expected_output
  end

  it 'can solve the example correctly (after 256 days)' do
    input_string = '3,4,3,1,2'
    input_days = 256
    expected_output = 26984457539

    expect(predict_fish_counts(input_string, input_days)).to eql expected_output
  end
end
