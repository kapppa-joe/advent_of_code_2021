require 'puzzle_day18'

def pair(a, b)
  Day18::Pair.new(a, b)
end

describe Day18::SnailfishMaths do
  let(:parse_literal) { ->(str) { described_class.parse_literal(str) } }

  describe '::parse_literal' do
    it 'convert a string notation of a simple pair' do
      input = '[1,2]'
      expected = pair(1, 2)

      actual = parse_literal.call(input)

      expect(actual).to eq expected
    end

    it 'can handle number with more than 1 digit' do
      input = '[012,3405]'
      expected = pair(12, 3405)

      actual = parse_literal.call(input)

      expect(actual).to eq expected
    end

    it 'converts a level 2 nested pair' do
      input = '[[1,2],3]'
      expected = pair(
        pair(1, 2),
        3
      )

      actual = parse_literal.call(input)

      expect(actual).to eq expected
    end

    it 'converts another level 2 nested pair' do
      input = '[9,[8,7]]'
      expected = pair(
        9,
        pair(8, 7)
      )

      actual = parse_literal.call(input)

      expect(actual).to eq expected
    end

    it 'converts a complex nested string correctly' do
      input = '[[[[1,3],[5,3]],[[1,3],[8,7]]],[[[4,9],[6,9]],[[8,2],[7,3]]]]'
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

    it 'a literal num has the same level as its parent pair' do
      tree = parse_literal.call('[[[[1,2],[3,4]],[[5,6],[7,8]]],9]')

      node = tree.left.left.left.left
      expect(node.num).to eq 1
      expect(node.level).to eq 4

      8.times { node = node.to_right }
      expect(node.num).to eq 9
      expect(node.level).to eq 1
    end
  end
end

describe Day18::Node do
  describe '#parent' do
    it 'return nil if it is the outermost pair' do
      expect(pair(1, 2).parent).to eq nil
    end

    it 'returns the ref of its parent if it is an inner node' do
      root = pair(
        pair(1, pair(2, 3)),
        4
      )
      expect(root.left.parent).to eq root
      expect(root.right.parent).to eq root
      expect(root.left.left.parent).to eq root.left
    end
  end

  describe '#root? #left? #right?' do
    it 'root? indicates whether a node is the root' do
      node = pair(
        pair(1, pair(2, 3)),
        4
      )
      expect(node.root?).to eq true
      expect(node.left.root?).to eq false
    end

    it 'left? indicates whether a node is at the left of a pair' do
      node = pair(
        pair(1, pair(2, 2)),
        4
      )
      expect(node.left?).to eq false
      expect(node.left.left?).to eq true
      expect(node.right.left?).to eq false
      expect(node.left.left.left?).to eq true
      expect(node.left.right.left?).to eq false
    end

    it 'right? indicates whether a node is at the right of a pair' do
      node = pair(
        pair(1, pair(2, 2)),
        4
      )
      expect(node.right?).to eq false
      expect(node.left.right?).to eq false
      expect(node.right.right?).to eq true
      expect(node.left.left.right?).to eq false
      expect(node.left.right.right?).to eq true
      expect(node.left.right.left.right?).to eq false
      expect(node.left.right.right.right?).to eq true
    end
  end

  describe '#to_left, #to_right' do
    it '#to_left returns the node at the left of current node' do
      input = '[[[[1,2],[3,4]],[[5,6],[7,8]]],[[[9,10],[11,12]],[[13,14],[15,16]]]]'
      test_tree = Day18::SnailfishMaths.parse_literal(input)

      node = test_tree.left.right.left.right
      expect(node.num).to eq 6

      5.downto(1).each do |i|
        node = node.to_left
        expect(node.num).to eq i
      end

      expect(node.to_left).to eq nil
    end

    it '#to_right returns the node at the left of current node' do
      input = '[[[[1,2],[3,4]],[[5,6],[7,8]]],[[[9,10],[11,12]],[[13,14],[15,16]]]]'
      test_tree = Day18::SnailfishMaths.parse_literal(input)

      node = test_tree.left.right.left.right
      expect(node.num).to eq 6

      (7..16).each do |i|
        node = node.to_right
        expect(node.num).to eq i
      end

      expect(node.to_right).to eq nil
    end
  end

  it '#to_left and #to_right works for non-fully occupied tree' do
    input = '[[[9,[3,8]],[[0,9],6]],[[[3,7],[4,9]],3]]'
    test_tree = Day18::SnailfishMaths.parse_literal(input)
    expected_numbers = [9, 3, 8, 0, 9, 6, 3, 7, 4, 9, 3]

    node = test_tree.left.left.left
    expected_numbers.each do |expected|
      expect(node.num).to eq expected
      node = node.to_right
    end

    
  end

  describe '#leftmost' do
    it 'returns the node at the leftmost' do
      input = '[[[9,[3,8]],[[0,5],6]],[[[3,7],[4,3]],3]]'

      test_tree = Day18::SnailfishMaths.parse_literal(input)
      node = test_tree.left.right.left.right
      leftmost_node = node.leftmost_node
      expect(leftmost_node.num).to eq 9
      expect(leftmost_node.to_left).to eq nil

      leftmost_node2 = test_tree.leftmost_node
      expect(leftmost_node2.num).to eq 9
    end
  end

  describe '#each_node' do
    it 'return an enum that traverse through each literal num node from left to' do
      input = '[[[9,[3,8]],[[0,5],6]],[[[3,7],[4,3]],3]]'
      test_tree = Day18::SnailfishMaths.parse_literal(input)

      expected = [9, 3, 8, 0, 5, 6, 3, 7, 4, 3, 3]

      test_tree.each_node.with_index do |node, index|
        expect(node.num).to eq expected[index]
      end
    end
  end
end
