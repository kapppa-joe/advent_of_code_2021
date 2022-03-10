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

  describe '#total_syntax_score acceptance test' do
    it 'solve the example case correctly' do
      input = example_case_of_day_10
      expected_output = 26397

      expect(subject.total_syntax_score(input)).to eql expected_output
    end
  end
end
