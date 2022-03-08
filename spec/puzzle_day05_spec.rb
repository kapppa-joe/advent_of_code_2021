describe 'Day 05' do
  require 'puzzle_day05'

  EXAMPLE_INPUT_DAY_05 =
    <<~STR.chomp.split("\n")
      0,9 -> 5,9
      8,0 -> 0,8
      9,4 -> 3,4
      2,2 -> 2,1
      7,0 -> 7,4
      6,4 -> 2,0
      0,9 -> 2,9
      3,4 -> 1,4
      0,0 -> 8,8
      5,5 -> 8,2
    STR

  describe 'parse_input_day_05' do
    it 'returns an empty array when given an empty string' do
      input = ''
      expected_output = []

      expect(parse_input_day_05(input)).to eql expected_output
    end

    it 'returns array [1, 2, 3, 4] when given a string "1, 2 -> 3, 4"' do
      input = '1,2 -> 3,4'
      expected_output = [1, 2, 3, 4]

      expect(parse_input_day_05(input)).to eql expected_output
    end

    it 'returns nested array [[0, 9], [5, 9] when given a string "0,9 -> 5,9"' do
      input = '0,9 -> 5,9'
      expected_output = [0, 9, 5, 9]

      expect(parse_input_day_05(input)).to eql expected_output
    end

    it 'can parse input with more than one digit in coordinates' do
      input = '682,519 -> 682,729'
      expected_output = [682, 519, 682, 729]

      expect(parse_input_day_05(input)).to eql expected_output
    end
  end

  describe 'horizontal?' do
    it 'return false if given an empty array' do
      input = []
      expected_output = false

      expect(horizontal?(input)).to eql expected_output
    end

    it 'return true when given nested array [[1, 1], [3, 1]]' do
      input = [1, 1, 3, 1]
      expected_output = true

      expect(horizontal?(input)).to eql expected_output
    end

    it 'return false when given nested array [[1, 1], [1, 3]]' do
      input = [1, 1, 1, 3]
      expected_output = false

      expect(horizontal?(input)).to eql expected_output
    end
  end

  describe 'vertical?' do
    it 'return false if given an empty array' do
      input = []
      expected_output = false

      expect(vertical?(input)).to eql expected_output
    end

    it 'return false when given nested array [[1, 1], [3, 1]]' do
      input = [1, 1, 3, 1]
      expected_output = false

      expect(vertical?(input)).to eql expected_output
    end

    it 'return true when given nested array [[1, 1], [1, 3]]' do
      input = [1, 1, 1, 3]
      expected_output = true

      expect(vertical?(input)).to eql expected_output
    end
  end

  describe '#update_vent_diagram' do
    it 'return { [0, 0] => 1 } if given diagram is empty and vent = 0,0 -> 0,0' do
      input_diagram = make_diagram
      input_vent = parse_input_day_05('0,0 -> 0,0')
      expected_output = { [0, 0] => 1 }

      expect(update_vent_diagram(input_diagram, input_vent)).to eql expected_output
    end

    it 'updates the diagram with horizontal vents' do
      input_diagram = make_diagram
      input_vent = parse_input_day_05('0,0 -> 3,0')
      expected_output = { [0, 0] => 1, [1, 0] => 1, [2, 0] => 1, [3, 0] => 1 }

      expect(update_vent_diagram(input_diagram, input_vent)).to eql expected_output
    end

    it 'updates the diagram with vertical vents' do
      input_diagram = make_diagram
      input_vent = parse_input_day_05('0,0 -> 0,3')
      expected_output = { [0, 0] => 1, [0, 1] => 1, [0, 2] => 1, [0, 3] => 1 }

      expect(update_vent_diagram(input_diagram, input_vent)).to eql expected_output
    end

    it 'updates the diagram with diagonal vents (of 45 degrees)' do
      input_diagram = make_diagram
      input_vent = parse_input_day_05('1,1 -> 4,4')
      expected_output = { [1, 1] => 1, [2, 2] => 1, [3, 3] => 1, [4, 4] => 1 }

      expect(update_vent_diagram(input_diagram, input_vent)).to eql expected_output
    end

    it 'updates the diagram with diagonal vents (of 135 degrees)' do
      input_diagram = make_diagram
      input_vent = parse_input_day_05('4,1 -> 1,4')
      expected_output = { [1, 4] => 1, [2, 3] => 1, [3, 2] => 1, [4, 1] => 1 }

      expect(update_vent_diagram(input_diagram, input_vent)).to eql expected_output
    end

    it 'updates the diagram with diagonal vents (of 215 degrees)' do
      input_diagram = make_diagram
      input_vent = parse_input_day_05('4,4 -> 1,1')
      expected_output = { [1, 1] => 1, [2, 2] => 1, [3, 3] => 1, [4, 4] => 1 }

      expect(update_vent_diagram(input_diagram, input_vent)).to eql expected_output
    end

    it 'updates the diagram with diagonal vents (of 315 degrees)' do
      input_diagram = make_diagram
      input_vent = parse_input_day_05('1,4 -> 4,1')
      expected_output = { [1, 4] => 1, [2, 3] => 1, [3, 2] => 1, [4, 1] => 1 }

      expect(update_vent_diagram(input_diagram, input_vent)).to eql expected_output
    end

    it 'updates the diagram correctly even if vent is drawn in reverse direction' do
      input_diagram = make_diagram
      input_vent = parse_input_day_05('0,3 -> 0,0')
      expected_output = { [0, 0] => 1, [0, 1] => 1, [0, 2] => 1, [0, 3] => 1 }

      expect(update_vent_diagram(input_diagram, input_vent)).to eql expected_output
    end

    it 'increase the number in diagram if two vents overlaps' do
      input_diagram = update_vent_diagram(make_diagram, parse_input_day_05('0,3 -> 0,0'))
      input_vent = parse_input_day_05('0,1 -> 0,4')
      expected_output = { [0, 0] => 1, [0, 1] => 2, [0, 2] => 2, [0, 3] => 2, [0, 4] => 1 }

      expect(update_vent_diagram(input_diagram, input_vent)).to eql expected_output
    end
  end

  describe '#count_overlaps acceptance test' do
    it 'solve the example case for part A correctly' do
      input = EXAMPLE_INPUT_DAY_05
      expected_output = 5

      expect(count_overlaps(input)).to eql expected_output
    end
    it 'solve the example case for part B correctly' do
      input = EXAMPLE_INPUT_DAY_05
      expected_output = 12

      expect(count_overlaps(input, count_diagonals: true)).to eql expected_output
    end
  end
end
