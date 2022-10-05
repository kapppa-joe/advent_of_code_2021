module Day18
  class SnailfishMaths
    def self.find_matching_brackets(str)
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
      # convert literal representation to Pair object
      curr_num = nil
      stack = []

      str.chars.each do |chr|
        case chr
        when '0'..'9'
          curr_num = curr_num.nil? ? chr.to_i : curr_num * 10 + chr.to_i
        when '['
          stack.push(Pair.new(nil, nil))
        when ','
          curr_pair = stack.last
          curr_pair.insert(curr_num) if curr_num
          curr_num = nil
        when ']'
          curr_pair = stack.last
          curr_pair.insert(curr_num) if curr_num
          curr_num = nil
          if stack.length > 1
            curr_pair = stack.pop
            stack.last.insert(curr_pair)
          end
        end
      end
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

    def to_left
      return @parent.left if right?
      return nil if root?

      node = @parent
      node = node.parent while node.left?

      return nil if node.root?

      node = node.parent.left
      node = node.right while node.is_a?(Day18::Pair)
      node
    end

    def to_right
      return @parent.right if left?
      return nil if root?

      node = @parent
      node = node.parent while node.right?

      return nil if node.root?

      node = node.parent.right
      node = node.left while node.is_a?(Day18::Pair)
      node
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

    def to_s
      "#<Pair \n#{indenter}left : #{@left}, \n#{indenter}right: #{@right}>"
    end

    def indenter
      "|#{' ' * 4}" * @level
    end

    def inc_level
      @level += 1
      @left.inc_level
      @right.inc_level
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

    def ==(other)
      return false unless other.is_a?(Literal)

      @num == other.num
    end

    def inc_level; end

    def level
      @parent.level
    end
  end
end
