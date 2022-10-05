require 'puzzle_day18'

describe Day18::SnailfishMaths do
  let(:parse_literal) { ->(str) { described_class.parse_literal(str) } }
  describe '::parse_literal' do
    it 'convert a string notation of a simple pair' do
      input = '[1,2]'
      actual = parse_literal.call(input)

      expect(actual).to be_a(Day18::Pair)
      expect(actual.left).to eq 1
      expect(actual.right).to eq 2
    end

    it 'converts a level 2 nested pair' do
      input = '[[1,2],3]'
      actual = parse_literal.call(input)
      expect(actual).to be_a(Day18::Pair)
      expect(actual.left).to be_a(Day18::Pair)
      expect(actual.left.left).to eq 1
      expect(actual.left.right).to eq 2
      expect(actual.right).to eq 3
    end

    it 'converts another level 2 nested pair' do
      input = '[9,[8,7]]'
      actual = parse_literal.call(input)

      expect(actual).to be_a(Day18::Pair)
      expect(actual.left).to eq 9
      expect(actual.right).to be_a(Day18::Pair)
      expect(actual.right.left).to eq 8
      expect(actual.right.right).to eq 7
    end

    it 'converts a complex nested string correctly' do
      input = '[[[[1,3],[5,3]],[[1,3],[8,7]]],[[[4,9],[6,9]],[[8,2],[7,3]]]]'
      def pair(a, b)
        Day18::Pair.new(a, b)
      end
      expected = pair(
        pair(pair(pair(1, 3), pair(5, 3)), pair(pair(1, 3), pair(8, 7))),
        pair(pair(pair(4, 9), pair(6, 9)), pair(pair(8, 2), pair(7, 3)))
      )

      actual = parse_literal.call(input)
      expect(actual).to eq expected
    end
  end

  describe '::find_matching_brackets' do
    test_cases = %w[
      [1,2]
      [[1,2],3]
      [[1,9],[8,5]]
      [[[[1,3],[5,3]],[[1,3],[8,7]]],[[[4,9],[6,9]],[[8,2],[7,3]]]]
    ]

    it 'return the position of matching brackets' do
      input_string = '[1,2]'
      expected = {
        0 => 4
      }
      actual = described_class.find_matching_brackets(input_string)

      expect(actual).to eq expected
    end

    it 'can handle nested pairs' do
      input_string = '[[1,2],3]'
      expected = {
        0 => 8,
        1 => 5
      }
      actual = described_class.find_matching_brackets(input_string)

      expect(actual).to eq expected
    end

    it 'can handle two nested pairs' do
      input_string = '[[1,9],[8,5]]'
      expected = {
        0 => 12,
        1 => 5,
        7 => 11
      }
      actual = described_class.find_matching_brackets(input_string)

      expect(actual).to eq expected
    end

    it 'can handle complex case' do
      input_string = '[[[[1,3],[5,3]],[[1,3],[8,7]]],[[[4,9],[6,9]],[[8,2],[7,3]]]]'
      expected = {
        0 => 60,
        1 => 29,
        16 => 28,
        17 => 21,
        2 => 14,
        23 => 27,
        3 => 7,
        31 => 59,
        32 => 44,
        33 => 37,
        39 => 43,
        46 => 58,
        47 => 51,
        53 => 57,
        9 => 13
      }
      actual = described_class.find_matching_brackets(input_string)
      expect(actual).to eq expected
    end
  end
end

describe Day18::Pair do
  let(:parse_literal) { ->(str) { Day18::SnailfishMaths.parse_literal(str) } }
  describe '#==' do
    it 'compares simple pairs correctly' do
      pair_a = described_class.new(1, 2)
      pair_b = described_class.new(1, 1)
      pair_c = described_class.new(1, 2)

      expect(pair_a).not_to eq pair_b
      expect(pair_a).to eq pair_c
    end
  end

  describe '#level' do
    it 'return how deeply nested a pair is' do
      pair_a = parse_literal.call('[1, 2]')
      expect(pair_a.level).to eq 1

      pair_b = parse_literal.call('[[1,2],3]')
      expect(pair_b.level).to eq 1
      expect(pair_b.left.level).to eq 2

      pair_c = parse_literal.call('[[[[1,3],[5,3]],[[1,3],[8,7]]],[[[4,9],[6,9]],[[8,2],[7,3]]]]')
      expect(pair_c.level).to eq 1
      expect(pair_c.left.level).to eq 2
      expect(pair_c.left.right.level).to eq 3
      expect(pair_c.right.left.right.level).to eq 4
    end
  end
end
