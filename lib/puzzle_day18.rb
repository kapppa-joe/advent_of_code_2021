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
      node.inc_level
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

    def inc_level
      @level += 1
      @left.inc_level
      @right.inc_level
    end

    def run_explode_action
      raise 'should run explode action from root' unless root?

      each_node do |node|
        if node.should_explode?
          node.explode
          return true
        end
      end

      false
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
  end

  class Literal < Node
    attr_reader :num

    def initialize(num)
      @num = num
    end

    def to_s
      @num.to_s
    end

    def add(new_num)
      @num += new_num
    end

    def ==(other)
      return false unless other.is_a?(Literal)

      @num == other.num
    end

    def inc_level; end

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
  end
end
