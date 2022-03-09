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

  describe Day08::SegmentDisplay do
    
  end
end
