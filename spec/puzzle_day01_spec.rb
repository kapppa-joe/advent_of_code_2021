describe 'Day 01' do
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

  describe '#sum_sliding_windows' do
    it 'return an empty array if given an array of size <= 2' do
      expect(sum_sliding_windows([])).to eql []
      expect(sum_sliding_windows([0])).to eql []
      expect(sum_sliding_windows([0, 1])).to eql []
    end

    it 'return [6] if given an array [1,2,3]' do
      input = [1, 2, 3]
      expected_output = [6]

      expect(sum_sliding_windows(input)).to eql expected_output
    end

    it 'return [9] if given an array [2,3,4]' do
      input = [2, 3, 4]
      expected_output = [9]

      expect(sum_sliding_windows(input)).to eql expected_output
    end

    it 'return [6, 9] if given an array [1, 2, 3, 4]' do
      input = [1, 2, 3, 4]
      expected_output = [6, 9]

      expect(sum_sliding_windows(input)).to eql expected_output
    end

    it 'return [6, 9, 11] if given an array [1, 3, 2, 4, 5]' do
      input = [1, 3, 2, 4, 5]
      expected_output = [6, 9, 11]

      expect(sum_sliding_windows(input)).to eql expected_output
    end
  end

  describe '#count_increase_by_sliding_window' do
    it 'return 0 if given an array with length < 4' do
      test_cases = [
        [], [1], [1, 2], [1, 2, 3]
      ]
      test_cases.each do |input|
        expect(count_increase_by_sliding_window(input)).to eq 0
      end
    end

    it 'return 1 if given array [1, 2, 3, 4]' do
      input = [1, 2, 3, 4]
      expected_output = 1

      expect(count_increase_by_sliding_window(input)).to eql expected_output
    end

    it 'return 4 if given array [11, 19, 4, 19, 7, 8, 14, 10, 14, 11]' do
      input = [11, 19, 4, 19, 7, 8, 14, 10, 14, 11]
      expected_output = 4

      expect(count_increase_by_sliding_window(input)).to eql expected_output
    end
  end

  describe '#count_increase_by_sliding_window acceptance test' do
    it 'solves the example case correctly' do
      input = [199, 200, 208, 210, 200, 207, 240, 269, 260, 263]
      expected_output = 5

      expect(count_increase_by_sliding_window(input)).to eql expected_output
    end
  end
end
