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
          curr_num ||= chr.to_i
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

  class Pair
    attr_reader :left, :right, :level

    def initialize(left = nil, right = nil)
      @left = left
      @right = right
      @level = 1
    end

    def insert(node)
      raise ArgumentError unless node.is_a?(Pair) || node.is_a?(Integer)

      if @left.nil?
        @left = node
      elsif @right.nil?
        @right = node
      else
        raise RuntimeError('trying to insert into a fully filled pair')
      end
      node.inc_level if node.is_a?(Pair)
    end

    def ==(other)
      return false unless other.is_a?(Pair)

      @left = other.left && @right == other.right
    end

    def to_s
      "#<Pair \n#{indenter}left : #{@left}, \n#{indenter}right: #{@right}>"
    end

    def indenter
      "|#{' ' * 4}" * @level
    end

    def inc_level
      @level += 1
      @left.inc_level if @left.is_a?(Pair)
      @right.inc_level if @right.is_a?(Pair)
    end
  end
end
