module Day18
  class SnailfishMaths
    def self.find_matching_brackets(str)
      # implemented but turns out not necessary at all :) ...
      dict = {}
      stack = []
      str.chars.each_with_index do |chr, index|
        case chr
        when '['
          stack.push(index)
        when ']'
          left = stack.pop
          dict[left] = index
        end
      end
      dict
    end

    def self.parse_literal(str)
      # convert literal representation to a tree of Pair objects
      curr_num = nil
      stack = []

      str.chars.each do |chr|
        case chr
        when '0'..'9'
          curr_num = if curr_num.nil?
                       chr.to_i
                     else
                       curr_num * 10 + chr.to_i
                     end
        when '['
          stack.push(Pair.new(nil, nil))
        when ','
          curr_pair = stack.last
          curr_pair.insert(curr_num) unless curr_num.nil?
          curr_num = nil
        when ']'
          curr_pair = stack.last
          curr_pair.insert(curr_num) unless curr_num.nil?
          curr_num = nil
          if stack.length > 1
            curr_pair = stack.pop
            stack.last.insert(curr_pair)
          end
        end
      end

      raise ArgumentError("the input string doesn't compute to a valid pair") if stack.length != 1

      stack.pop
    end

    def self.add_two_pairs(pair_a, pair_b)
      new_pair = Pair.new(pair_a, pair_b)
      new_pair.update_level
      new_pair.run_reduction
    end

    def self.sum_list_from_strings(list_of_string)
      list_of_string.map do |string|
        parse_literal(string)
      end.reduce do |curr_pair, new_pair|
        add_two_pairs(curr_pair, new_pair)
      end
    end

    def self.max_magnitude_from_summing_any_two(list_of_string)
      list_of_string.permutation(2).map do |two_strings|
        sum_list_from_strings(two_strings).magnitude
      end.max
    end
  end

  class Node
    attr_accessor :parent

    def initialize
      raise NotImplementedError
    end

    def root?
      @parent.nil?
    end

    def left?
      # false
      !root? && @parent.left.eql?(self)
    end

    def right?
      !root? && @parent.right.eql?(self)
    end

    def leftmost_node
      node = to_root
      node = node.left until node.is_a?(Literal)
      node
    end

    def to_root
      node = self
      node = node.parent until node.root?
      node
    end

    def each_node
      return to_enum(:each_node) unless block_given?

      node = leftmost_node
      until node.nil?
        yield node
        node = node.to_right
      end
    end
  end

  class Pair < Node
    attr_reader :left, :right, :level

    def initialize(left = nil, right = nil)
      @left = wrap(left)
      @right = wrap(right)

      @left.parent = self unless @left.nil?
      @right.parent = self unless @left.nil?
      @level = 1
    end

    def two_regular_numbers?
      @left.is_a?(Literal) && @right.is_a?(Literal)
    end

    def wrap(node)
      node.is_a?(Integer) ? Literal.new(node) : node
    end

    def insert(node)
      raise ArgumentError unless node.is_a?(Pair) || node.is_a?(Literal) || node.is_a?(Integer)

      node = wrap(node)
      node.parent = self

      if @left.nil?
        @left = node
      elsif @right.nil?
        @right = node
      else
        raise RuntimeError('trying to insert into a fully filled pair')
      end
      node.update_level
    end

    def ==(other)
      return false unless other.is_a?(Pair)

      @left == other.left && @right == other.right
    end

    def inspect
      "#<Pair \n#{indenter}left : #{@left}, \n#{indenter}right: #{@right}>"
    end

    def to_s
      "[#{@left},#{@right}]"
    end

    def indenter
      "|#{' ' * 4}" * @level
    end

    def update_level
      @level = root? ? 1 : @parent.level + 1
      @left.update_level
      @right.update_level
    end

    def run_explode_action
      each_node do |node|
        if node.should_explode?
          node.explode
          return true
        end
      end

      false
    end

    def run_split_action
      each_node do |node|
        if node.should_split?
          node.split
          return true
        end
      end

      false
    end

    def run_action_rules
      # try run explode or split on the tree for once.
      # if both action didn't fire, return false. else return true

      run_explode_action || run_split_action
    end

    def run_reduction
      raise 'should run reduction from root' unless root?

      loop do
        action_taken = run_action_rules
        # if action_taken is false, the tree is already fully reduced
        return self unless action_taken
      end
    end

    def explode
      raise 'trying to explode a pair with nested pair inside' if @left.is_a?(Day18::Pair) || @right.is_a?(Day18::Pair)

      @left.to_left&.add(@left.num)
      @right.to_right&.add(@right.num)
      replace_self_with_zero
    end

    def delete_left
      @left = nil
    end

    def delete_right
      @right = nil
    end

    def replace_self_with_zero
      raise 'try to replace root with zero' if root?

      left? ? @parent.delete_left : @parent.delete_right
      @parent.insert(0)
    end

    def magnitude
      @left.magnitude * 3 + @right.magnitude * 2
    end
  end

  class Literal < Node
    attr_reader :num

    def initialize(num)
      @num = num
    end

    def to_s
      @num.to_s
    end

    def magnitude
      @num
    end

    def add(new_num)
      @num += new_num
    end

    def ==(other)
      return false unless other.is_a?(Literal)

      @num == other.num
    end

    def update_level; end

    def level
      @parent.level
    end

    def to_left
      return nil if root?

      # seek common parent
      node = self
      node = node.parent while node.left?

      # return nil if it is already the rightmost node
      return nil if node.root?

      # drill down the right branch and seek the leftmost literal node
      node = node.parent.left
      node = node.right while node.is_a?(Day18::Pair)
      node
    end

    def to_right
      return nil if root?

      node = self
      node = node.parent while node.right?

      return nil if node.root?

      node = node.parent.right
      node = node.left while node.is_a?(Day18::Pair)
      node
    end

    def should_explode?
      level > 4 && @parent.two_regular_numbers?
    end

    def should_split?
      @num >= 10
    end

    def explode
      @parent.explode
    end

    def split
      new_left = @num / 2
      new_right = @num / 2 + (@num.even? ? 0 : 1)
      replace_self_with_pair(new_left, new_right)
    end

    def replace_self_with_pair(left, right)
      raise 'try to replace root with zero' if root?

      new_pair = Day18::Pair.new(left, right)
      left? ? @parent.delete_left : @parent.delete_right
      @parent.insert(new_pair)
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  require_relative './utils'
  input_array = read_input_file(18, 'string')
  result_pair = Day18::SnailfishMaths.sum_list_from_strings(input_array)

  part_a_solution = result_pair.magnitude
  puts "solution for part A: #{part_a_solution}"

  part_b_solution = Day18::SnailfishMaths.max_magnitude_from_summing_any_two(input_array)
  puts "solution for part B: #{part_b_solution}"
end
