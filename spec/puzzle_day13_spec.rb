require 'puzzle_day13'

day_13_example = %w[
  6,10 0,14 9,10 0,3 10,4 4,11 6,0 6,12 4,1 0,13 10,12
  3,4 3,0 8,4 1,10 2,14 8,10 9,0
] + ['', 'fold along y=7', 'fold along x=5']

describe Day13::Origami do
  describe '#parse_input' do
    it 'parse the input into an array of coordinates and an array of folding instruction' do
      input = day_13_example
      expected_output = {
        dots: [
          [6, 10], [0, 14], [9, 10], [0, 3], [10, 4],
          [4, 11], [6, 0], [6, 12], [4, 1], [0, 13],
          [10, 12], [3, 4], [3, 0], [8, 4], [1, 10],
          [2, 14], [8, 10], [9, 0]
        ],
        folding_instruction: [
          [:y, 7],
          [:x, 5]
        ]
      }

      expect(subject.parse_input(input)).to eql expected_output
    end
  end

  before(:each) do
    origami = subject.parse_input(day_13_example)
    @example_dots = origami[:dots]
    @example_fold_inst = origami[:folding_instruction]
  end

  describe '#fold' do
    context 'minimal case of 3x3 paper' do
      it 'return empty array when given empty array' do
        input = []
        expected_output = []
        folding_instruction = [:x, 1]

        actual_output = subject.fold_paper(input, *folding_instruction)
        expect(actual_output).to eql expected_output
      end

      context 'when fold along x = 1' do
        it 'move the dot from (2, 0) to (0, 0) when fold along x=1' do
          input = [[2, 0]]
          expected_output = [[0, 0]]
          folding_instruction = [:x, 1]

          actual_output = subject.fold_paper(input, *folding_instruction)
          expect(actual_output).to eql expected_output
        end

        it 'move the dot from (2, 1) to (0, 1) when fold along x=1' do
          input = [[2, 1]]
          expected_output = [[0, 1]]
          folding_instruction = [:x, 1]

          actual_output = subject.fold_paper(input, *folding_instruction)
          expect(actual_output).to eql expected_output
        end

        it 'keep the dots at (0, 1) if (2, 1) is empty' do
          input = [[0, 1]]
          expected_output = [[0, 1]]
          folding_instruction = [:x, 1]

          actual_output = subject.fold_paper(input, *folding_instruction)
          expect(actual_output).to eql expected_output
        end

        it 'does not add duplicated dot when having both (2, 1) and (0, 1) and fold along x=1' do
          input = [[0, 1], [2, 1]]
          expected_output = [[0, 1]]
          folding_instruction = [:x, 1]

          actual_output = subject.fold_paper(input, *folding_instruction)
          expect(actual_output).to eql expected_output
        end

        it 'remove dots lying on the axis x = 1' do
          input = [[0, 0], [1, 1], [2, 2]]
          expected_output = [[0, 0], [0, 2]]
          folding_instruction = [:x, 1]

          actual_output = subject.fold_paper(input, *folding_instruction)
          expect(actual_output).to eql expected_output
        end
      end

      context 'when fold along y = 1' do
        it 'move the dots from y > 1 to y < 1 as expected' do
          input = [[0, 0], [1, 0], [1, 1], [2, 2]]
          expected_output = [[0, 0], [1, 0], [2, 0]]
          folding_instruction = [:y, 1]

          actual_output = subject.fold_paper(input, *folding_instruction)
          expect(actual_output).to eql expected_output
        end
      end
    end

    context 'larger case of 5x5 paper' do
      it 'works as expected with folding along x = 2' do
        input = [[0, 0], [0, 2], [1, 3], [2, 4], [2, 2], [4, 3], [3, 1], [3, 2]]
        expected_output = [[0, 0], [0, 2], [0, 3], [1, 1], [1, 2], [1, 3]]
        folding_instruction = [:x, 2]

        actual_output = subject.fold_paper(input, *folding_instruction)
        expect(actual_output).to match_array expected_output
      end

      it 'works as expected with folding along y = 2' do
        input = [[0, 0], [0, 2], [1, 3], [2, 4], [2, 2], [4, 3], [3, 1], [3, 2]]
        expected_output = [[0, 0], [1, 1], [2, 0], [3, 1], [4, 1]]
        folding_instruction = [:y, 2]

        actual_output = subject.fold_paper(input, *folding_instruction)
        expect(actual_output).to match_array expected_output
      end
    end

    context 'example case' do
      it 'return 17 dots after first folding' do
        input = @example_dots
        folding_instruction = @example_fold_inst[0]

        actual_output = subject.fold_paper(input, *folding_instruction)
        expect(actual_output.length).to eql 17
      end

      it 'return the expected square pattern of 16 dots after second folding' do
        input = @example_dots
        folding_instruction = @example_fold_inst[0]
        first_fold, second_fold = @example_fold_inst
        expected_output = [
          [0, 0], [1, 0], [2, 0], [3, 0], [4, 0],
          [0, 1], [0, 2], [0, 3], [0, 4], [1, 4],
          [2, 4], [3, 4], [4, 4], [4, 3], [4, 2],
          [4, 1]
        ]

        after_1st_folding = subject.fold_paper(input, *first_fold)
        actual_output = subject.fold_paper(after_1st_folding, *second_fold)
        expect(actual_output.length).to eql 16
        expect(actual_output).to match_array expected_output
      end
    end
  end
end
