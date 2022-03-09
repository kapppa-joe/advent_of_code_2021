describe 'Day08' do
  require 'puzzle_day08'

  example_input_day_08 =
    <<~INPUT.chomp.split("\n")
      be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
      edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
      fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
      fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
      aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
      fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
      dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
      bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
      egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
      gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce
    INPUT

  describe 'parse_input_string' do
    it 'parse the a signal entry into two arrays of strings' do
      input =
        'defabc gcb dbafcg gc gcbed fbecgd begfdac fcbde cfge debag | gfce fgce bdefgca aebgd'
      expected_output = [
        %w[defabc gcb dbafcg gc gcbed fbecgd begfdac fcbde cfge debag],
        %w[gfce fgce bdefgca aebgd]
      ]

      expect(Day08.parse_input_string(input)).to eql expected_output
    end
  end

  describe 'count_1478_in_one_line' do
    it 'return 0 when given an empty array' do
      input = []
      expected_output = 0

      expect(Day08.count_1478_in_one_line(input)).to eql expected_output
    end

    it 'return 1 when input array contains a string that has 2 chars' do
      input = %w[gc]
      expected_output = 1

      expect(Day08.count_1478_in_one_line(input)).to eql expected_output
    end

    it 'return 1 when input array contains a string with 2 chars and a string with 5 chars' do
      input = %w[gc fcbde]
      expected_output = 1

      expect(Day08.count_1478_in_one_line(input)).to eql expected_output
    end

    it 'return 2 when input array contains "gc"(2 chars) and "cfge"(4 chars)' do
      input = %w[gc cfge]
      expected_output = 2

      expect(Day08.count_1478_in_one_line(input)).to eql expected_output
    end

    it 'return 2 when input array contains "gcb"(3 chars) and "bdefgca"(7 chars)' do
      input = %w[gcb bdefgca]
      expected_output = 2

      expect(Day08.count_1478_in_one_line(input)).to eql expected_output
    end

    it 'return 4 when input array contains the segment representation of all 10 digits' do
      input = %w[defabc gcb dbafcg gc gcbed fbecgd begfdac fcbde cfge debag]
      expected_output = 4

      expect(Day08.count_1478_in_one_line(input)).to eql expected_output
    end
  end

  describe 'count_1478s_in_all_entries' do
    it 'solves the example case correctly' do
      input = example_input_day_08
      expected_output = 26

      actual_output = Day08.count_1478s_in_all_entries(input)
      expect(actual_output).to eql expected_output
    end
  end

  describe 'sum_all_decoded_outputs acceptance test' do
    it 'can solve the larger example case correctly' do
      input = example_input_day_08
      expected_output = 61229
      expect(Day08.sum_all_decoded_outputs(input)).to eql expected_output
    end
  end

  describe Day08::SegmentDisplay do
    before(:all) do
      @example_answer = {
        8 => 'acedgfb',
        5 => 'cdfbe',
        2 => 'gcdfa',
        3 => 'fbcad',
        7 => 'dab',
        9 => 'cefabd',
        6 => 'cdfgeb',
        4 => 'eafb',
        0 => 'cagedb',
        1 => 'ab'
      }
    end

    before(:each) do
      input = 'acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf'
      @segment_display = described_class.new(input)
    end

    describe '#zero' do
      it 'return the segment pattern for number zero' do
        expect(@segment_display.zero).to eql @example_answer[0]
      end
    end

    describe '#one' do
      it 'return the segment pattern for number one' do
        expect(@segment_display.one).to eql @example_answer[1]
      end

      it 'identify the pattern for one in different cases' do
        input = 'edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc'
        expected_output = 'gc'

        expect(described_class.new(input).one).to eql expected_output
      end
    end

    describe '#two' do
      it 'return the segment pattern for number two' do
        expect(@segment_display.two).to eql @example_answer[2]
      end
    end

    describe '#three' do
      it 'return the segment pattern for number three' do
        expect(@segment_display.three).to eql @example_answer[3]
      end
    end

    describe '#four' do
      it 'return the segment pattern for number four' do
        expect(@segment_display.four).to eql @example_answer[4]

        input = 'edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc'
        expected_output = 'gfec'

        expect(described_class.new(input).four).to eql expected_output
      end
    end

    describe '#five' do
      it 'return the segment pattern for number five' do
        expect(@segment_display.five).to eql @example_answer[5]
      end
    end

    describe '#six' do
      it 'return the segment pattern for number six' do
        expect(@segment_display.six).to eql @example_answer[6]
      end
    end

    describe '#seven' do
      it 'return the segment pattern for number seven' do
        expect(@segment_display.seven).to eql @example_answer[7]

        input = 'edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc'
        expected_output = 'cbg'

        expect(described_class.new(input).seven).to eql expected_output
      end
    end

    describe '#eight' do
      it 'return the segment pattern for number eight' do
        expect(@segment_display.eight).to eql @example_answer[8]

        input = 'edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc'
        expected_output = 'gcadebf'

        expect(described_class.new(input).eight).to eql expected_output
      end
    end

    describe '#nine' do
      it 'return the segment pattern for number nine' do
        expect(@segment_display.nine).to eql @example_answer[9]
      end
    end

    describe '#match_pattern' do
      it 'return true if two strings are the same' do
        input = %w[ab ab]
        expected_output = true

        expect(@segment_display.match_pattern(*input)).to eql expected_output
      end

      it 'return false if string a gots a char that string b doesnt have' do
        input = %w[abc ab]
        expected_output = false

        expect(@segment_display.match_pattern(*input)).to eql expected_output
      end

      it 'return false if string b gots a char that string a doesnt have' do
        input = %w[ac abc]
        expected_output = false

        expect(@segment_display.match_pattern(*input)).to eql expected_output
      end

      it 'return true if two strings have the same set of chars but in different order' do
        input = %w[abcde ceabd]
        expected_output = true

        expect(@segment_display.match_pattern(*input)).to eql expected_output
      end
    end

    describe '#to_pattern' do
      it 'return the pattern of the given digit' do
        (0..9).each do |digit|
          expect(@segment_display.to_pattern(digit)).to eql @example_answer[digit]
        end
      end
    end

    describe '#decode_output acceptance test' do
      it 'can solve the 1st example case correctly' do
        expect(@segment_display.decode_output).to eql 5353
      end

      describe 'it can solve all the larger example cases correctly' do
        example_cases_answers = [
          8394, 9781, 1197, 9361, 4873,
          8418, 4548, 1625, 8717, 4315
        ]

        example_input_day_08.each_with_index do |input_string, index|
          it "case ##{index}, input: #{input_string}" do
            input = input_string
            expected_output = example_cases_answers[index]
            actual_output = described_class.new(input_string).decode_output

            expect(actual_output).to eql expected_output
          end
        end
      end
    end
  end
end
