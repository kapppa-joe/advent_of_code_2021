require 'puzzle_day10'

describe Day10::SyntaxScore do
  example_case_of_day_10 = [
    '[({(<(())[]>[[{[]{<()<>>',
    '[(()[<>])]({[<{<<[]>>(',
    '{([(<{}[<>[]}>{[]{[(<()>',
    '(((({<>}<{<{<>}{[]{[]{}',
    '[[<[([]))<([[{}[[()]]]',
    '[{[{({}]{}}([{[{{{}}([]',
    '{<[[]]>}<{[{[{[]{()[[[]',
    '[<(<(<(<{}))><([]([]()',
    '<{([([[(<>()){}]>(<<{{',
    '<{([{{}}[<[[[<>{}]]]>[]]'
  ]

  before(:each) do
    stub_const('Result', Day10::Result)
  end

  describe '#analyse_string' do
    it 'returns Result::OK when given an empty string' do
      expect(subject.analyse_string('')).to eql Result::Ok
    end

    it 'returns Result::Incomplete when having only the open bracket' do
      test_cases = ['[', '(', '{', '<']
      test_cases.each do |input|
        expect(subject.analyse_string(input)).to eql Result::Incomplete
      end
    end

    it 'returns Result::Corrupted when having only the close bracket' do
      test_cases = [']', ')', '}', '>']
      test_cases.each do |input|
        expect(subject.analyse_string(input)).to eql Result::Corrupted
      end
    end

    it 'returns Result::Ok when given a pair of matching brackets' do
      test_cases = ['<>', '()', '[]', '{}']
      test_cases.each do |input|
        expect(subject.analyse_string(input)).to eql Result::Ok
      end
    end

    it 'returns Result::Corrupted when having a pair of unmatched brackets' do
      test_cases = ['<)', '(>', '[}', '{]']
      test_cases.each do |input|
        expect(subject.analyse_string(input)).to eql Result::Corrupted
      end
    end

    describe 'it solves the example cases correctly' do
      test_cases = {
        '[({(<(())[]>[[{[]{<()<>>' => Day10::Result::Incomplete,
        '[(()[<>])]({[<{<<[]>>(' => Day10::Result::Incomplete,
        '{([(<{}[<>[]}>{[]{[(<()>' => Day10::Result::Corrupted,
        '(((({<>}<{<{<>}{[]{[]{}' => Day10::Result::Incomplete,
        '[[<[([]))<([[{}[[()]]]' => Day10::Result::Corrupted,
        '[{[{({}]{}}([{[{{{}}([]' => Day10::Result::Corrupted,
        '{<[[]]>}<{[{[{[]{()[[[]' => Day10::Result::Incomplete,
        '[<(<(<(<{}))><([]([]()' => Day10::Result::Corrupted,
        '<{([([[(<>()){}]>(<<{{' => Day10::Result::Corrupted,
        '<{([{{}}[<[[[<>{}]]]>[]]' => Day10::Result::Incomplete
      }

      test_cases.each do |input, expected_output|
        it "input: #{input}" do
          expect(subject.analyse_string(input)).to eql expected_output
        end
      end
    end

    context 'when input string is Corrupted' do
      it 'return an object containing the illegal char' do
        returned_object = subject.analyse_string('{([(<{}[<>[]}>{[]{[(<()>')
        expect(returned_object).to have_attributes(illegal_char: '}')
      end

      describe 'catch the illegal char correctly' do
        test_cases = {
          '{([(<{}[<>[]}>{[]{[(<()>' => '}',
          '[[<[([]))<([[{}[[()]]]' => ')',
          '[{[{({}]{}}([{[{{{}}([]' => ']',
          '[<(<(<(<{}))><([]([]()' => ')',
          '<{([([[(<>()){}]>(<<{{' => '>'
        }

        test_cases.each do |input, expected_illegal_char|
          it "test case: #{input}" do
            returned_object = subject.analyse_string(input)
            expect(returned_object.illegal_char).to eql expected_illegal_char
          end
        end
      end
    end
  end

  describe '#score_incomplete_chars' do
    it 'return 0 when given an empty array' do
      expect(subject.score_incomplete_chars([])).to eql 0
    end

    it 'return the points of each char when given an array with only one char' do
      test_cases = {
        [')'] => 1,
        [']'] => 2,
        ['}'] => 3,
        ['>'] => 4
      }
      test_cases.each do |input, expected_output|
        expect(subject.score_incomplete_chars(input)).to eql expected_output
      end
    end

    it 'multiply the points successively by 5' do
      input = '])}>'.chars
      expected_output = 294

      expect(subject.score_incomplete_chars(input)).to eql expected_output
    end

    describe 'solves the example cases correctly' do
      test_cases = {
        '}}]])})]' => 288_957,
        ')}>]})' => 5566,
        '}}>}>))))' => 1_480_781,
        ']]}}]}]}>' => 995_444
      }

      test_cases.each do |string, expected_output|
        it "test case: #{string}, expected output: #{expected_output}" do
          input = string.chars
          expect(subject.score_incomplete_chars(input)).to eql expected_output
        end
      end
    end
  end

  describe '#illegal_strings_total_scores acceptance test' do
    it 'solve the example case of part A correctly' do
      input = example_case_of_day_10
      expected_output = 26_397

      expect(subject.illegal_strings_total_scores(input)).to eql expected_output
    end
  end

  describe '#incomplete_strings_middle_score acceptance test' do
    it 'solve the example case of part B correctly' do
      input = example_case_of_day_10
      expected_output = 288957

      expect(subject.incomplete_strings_middle_score(input)).to eql expected_output
    end
  end
end
