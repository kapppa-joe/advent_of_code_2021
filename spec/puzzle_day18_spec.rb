require 'puzzle_day18'

def pair(a, b)
  Day18::Pair.new(a, b)
end

def parse_literal(str)
  Day18::SnailfishMaths.parse_literal(str)
end

describe Day18::SnailfishMaths do
  describe '::parse_literal' do
    it 'convert a string notation of a simple pair' do
      input = '[1,2]'
      expected = pair(1, 2)

      actual = parse_literal(input)

      expect(actual).to eq expected
    end

    it 'can handle number with more than 1 digit' do
      input = '[012,3405]'
      expected = pair(12, 3405)

      actual = parse_literal(input)

      expect(actual).to eq expected
    end

    it 'converts a level 2 nested pair' do
      input = '[[1,2],3]'
      expected = pair(
        pair(1, 2),
        3
      )

      actual = parse_literal(input)

      expect(actual).to eq expected
    end

    it 'converts another level 2 nested pair' do
      input = '[9,[8,7]]'
      expected = pair(
        9,
        pair(8, 7)
      )

      actual = parse_literal(input)

      expect(actual).to eq expected
    end

    it 'converts a complex nested string correctly' do
      input = '[[[[1,3],[5,3]],[[1,3],[8,7]]],[[[4,9],[6,9]],[[8,2],[7,3]]]]'
      expected = pair(
        pair(pair(pair(1, 3), pair(5, 3)), pair(pair(1, 3), pair(8, 7))),
        pair(pair(pair(4, 9), pair(6, 9)), pair(pair(8, 2), pair(7, 3)))
      )

      actual = parse_literal(input)
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

  describe '::add_two_pairs' do
    it 'handle basic example correctly' do
      pair_a = parse_literal('[[[[4,3],4],4],[7,[[8,4],9]]]')
      pair_b = parse_literal('[1,1]')
      expected = parse_literal('[[[[0,7],4],[[7,8],[6,0]]],[8,1]]')

      actual = described_class.add_two_pairs(pair_a, pair_b)

      expect(actual).to eq expected
    end
  end

  describe '::sum_list_from_strings' do
    describe 'basic examples' do
      input_list = %w[
        [1,1]
        [2,2]
        [3,3]
        [4,4]
        [5,5]
        [6,6]
      ]
      expected_results = {
        4 => '[[[[1,1],[2,2]],[3,3]],[4,4]]',
        5 => '[[[[3,0],[5,3]],[4,4]],[5,5]]',
        6 => '[[[[5,0],[7,4]],[5,5]],[6,6]]'
      }
      expected_results.each do |take_length, expected|
        it '' do
          expected_tree = parse_literal(expected)
          input = input_list[0...take_length]
          actual = described_class.sum_list_from_strings(input)
        end
      end
    end

    it 'solves larger example correctly' do
      input = %w[
        [[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]
        [7,[[[3,7],[4,3]],[[6,3],[8,8]]]]
        [[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]]
        [[[[2,4],7],[6,[0,5]]],[[[6,8],[2,8]],[[2,1],[4,5]]]]
        [7,[5,[[3,8],[1,4]]]]
        [[2,[2,2]],[8,[8,1]]]
        [2,9]
        [1,[[[9,3],9],[[9,0],[0,7]]]]
        [[[5,[7,4]],7],1]
        [[[[4,2],2],6],[8,7]]
      ]
      expected = parse_literal('[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]')

      actual = described_class.sum_list_from_strings(input)

      expect(actual).to eq expected
    end
  end

  describe '::max_magnitude_from_summing_any_two' do
    it 'solve the larger example case correctly' do
      input = %w[
        [[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]
        [[[5,[2,8]],4],[5,[[9,9],0]]]
        [6,[[[6,2],[5,6]],[[7,6],[4,7]]]]
        [[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]
        [[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]
        [[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]
        [[[[5,4],[7,7]],8],[[8,3],8]]
        [[9,3],[[9,9],[6,[4,9]]]]
        [[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]
        [[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]
      ]
      expected = 3993

      actual = described_class.max_magnitude_from_summing_any_two(input)

      expect(actual).to eq expected
    end
  end
end

describe Day18::Pair do
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
      pair_a = parse_literal('[1, 2]')
      expect(pair_a.level).to eq 1

      pair_b = parse_literal('[[1,2],3]')
      expect(pair_b.level).to eq 1
      expect(pair_b.left.level).to eq 2

      pair_c = parse_literal('[[[[1,3],[5,3]],[[1,3],[8,7]]],[[[4,9],[6,9]],[[8,2],[7,3]]]]')
      expect(pair_c.level).to eq 1
      expect(pair_c.left.level).to eq 2
      expect(pair_c.left.right.level).to eq 3
      expect(pair_c.right.left.right.level).to eq 4
    end

    it 'a literal num has the same level as its parent pair' do
      tree = parse_literal('[[[[1,2],[3,4]],[[5,6],[7,8]]],9]')

      node = tree.left.left.left.left
      expect(node.num).to eq 1
      expect(node.level).to eq 4

      8.times { node = node.to_right }
      expect(node.num).to eq 9
      expect(node.level).to eq 1
    end
  end

  describe '#magnitude' do
    describe 'calculate the magnitude of a pair correctly' do
      test_cases = [
        ['[9,1]', 29],
        ['[[9,1],[1,9]]', 129],
        ['[[1,2],[[3,4],5]]', 143],
        ['[[[[0,7],4],[[7,8],[6,0]]],[8,1]]', 1384],
        ['[[[[1,1],[2,2]],[3,3]],[4,4]]', 445],
        ['[[[[3,0],[5,3]],[4,4]],[5,5]]', 791],
        ['[[[[5,0],[7,4]],[5,5]],[6,6]]', 1137],
        ['[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]', 3488],
      ]
      test_cases.each do |input, expected|
        it "magnitude of #{input} => #{expected}" do
          actual = parse_literal(input).magnitude
          expect(actual).to eq expected
        end
      end
    end

    it 'calculate the larger example correctly' do
      input = '[[[[6,6],[7,6]],[[7,7],[7,0]]],[[[7,7],[7,7]],[[7,8],[9,9]]]]'
      expected = 4140

      actual = parse_literal(input).magnitude
      expect(actual).to eq expected
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

    node = test_tree.right.right

    expected_numbers.reverse.each do |expected|
      expect(node.num).to eq expected
      node = node.to_left
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

      leftmost_node = test_tree.leftmost_node
      expect(leftmost_node.num).to eq 9
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

  describe '#should_explode?' do
    it 'return true iff a pair is nested inside four pairs and consist of only two literal numbers' do
      input = '[[6,[5,[4,[3,2]]]],1]'
      test_tree = Day18::SnailfishMaths.parse_literal(input)

      node = test_tree.left.left
      expect(node.num).to eq 6
      expect(node.should_explode?).to eq false

      node = test_tree.left.right.right.left
      expect(node.num).to eq 4
      expect(node.should_explode?).to eq false

      node = test_tree.left.right.right.right.left
      expect(node.num).to eq 3
      expect(node.should_explode?).to eq true
    end
  end

  describe '#should_split?' do
    it 'return true iff a literal number is >= 10' do
      input = '[[[[0,7],4],[15,[0,10]]],[1,1]]'
      test_tree = Day18::SnailfishMaths.parse_literal(input)

      test_tree.each_node do |node|
        expect(node.should_split?).to eq(node.num == 15 || node.num == 10)
      end
    end
  end

  describe '#explode' do
    it 'carry out the explode action at a node' do
      tree = parse_literal('[[[[[9,8],1],2],3],4]')
      node_to_explode = tree.left.left.left.left.left
      expected = parse_literal('[[[[0,9],2],3],4]')

      node_to_explode.explode

      expect(tree).to eq expected
    end

    it 'raise an error if the pair does not consist of two regular numbers' do
      tree = parse_literal('[[[[[9,8],1],2],3],4]')
      node_to_explode = tree.left.left.left
      expect { node_to_explode.explode }.to raise_error(RuntimeError)
    end
  end

  describe '#run_explode_action' do
    describe 'it explode the leftmost pair that should explode' do
      test_cases = {
        '[7,[6,[5,[4,[3,2]]]]]' => '[7,[6,[5,[7,0]]]]',
        '[[6,[5,[4,[3,2]]]],1]' => '[[6,[5,[7,0]]],3]',
        '[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]' => '[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]',
        '[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]' => '[[3,[2,[8,0]]],[9,[5,[7,0]]]]'
      }
      test_cases.each do |input, expected|
        it "test case: #{input} => #{expected}" do
          tree = parse_literal(input)
          expected_tree = parse_literal(expected)

          tree.run_explode_action

          expect(tree).to eq expected_tree
          # verify that node levels are handle correctly
          expected_tree_node = expected_tree.leftmost_node
          tree.each_node do |tree_node|
            expect(tree_node.level).to eq expected_tree_node.level
            expected_tree_node = expected_tree_node.to_right
          end
        end
      end
    end
  end

  describe '#split' do
    it 'carry out split action at a node' do
      input = '[[[[0,7],4],[15,[0,13]]],[1,1]]'
      expected = '[[[[0,7],4],[[7,8],[0,13]]],[1,1]]'

      tree = parse_literal(input)
      expected_tree = parse_literal(expected)

      node = tree.left.right.left
      expect(node.num).to eq 15

      node.split

      expect(tree).to eq expected_tree

      # verify that node levels are handle correctly
      expected_tree_node = expected_tree.leftmost_node
      tree.each_node do |tree_node|
        expect(tree_node.level).to eq expected_tree_node.level
        expected_tree_node = expected_tree_node.to_right
      end
    end
  end

  describe '#run_split_action' do
    describe 'it split the leftmost number that should split' do
      test_cases = {
        '[[[[0,7],4],[15,[0,13]]],[1,1]]' => '[[[[0,7],4],[[7,8],[0,13]]],[1,1]]',
        '[[[[0,7],4],[[7,8],[0,13]]],[1,1]]' => '[[[[0,7],4],[[7,8],[0,[6,7]]]],[1,1]]'
      }
      test_cases.each do |input, expected|
        it "test case: #{input} => #{expected}" do
          tree = parse_literal(input)
          expected_tree = parse_literal(expected)

          tree.run_split_action

          expect(tree).to eq expected_tree

          # verify that node levels are handle correctly
          expected_tree_node = expected_tree.leftmost_node
          tree.each_node do |tree_node|
            expect(tree_node.level).to eq expected_tree_node.level
            expected_tree_node = expected_tree_node.to_right
          end
        end
      end
    end
  end

  describe '#run_reduction' do
    it 'run reduction on the example correctly' do
      input = '[[[[[4,3],4],4],[7,[[8,4],9]]],[1,1]]'
      expected = '[[[[0,7],4],[[7,8],[6,0]]],[8,1]]'

      tree = parse_literal(input)
      expected_tree = parse_literal(expected)

      tree.run_reduction

      expect(tree).to eq expected_tree

      # verify that node levels are handle correctly
      expected_tree_node = expected_tree.leftmost_node
      tree.each_node do |tree_node|
        expect(tree_node.level).to eq expected_tree_node.level
        expected_tree_node = expected_tree_node.to_right
      end
    end
  end
end
