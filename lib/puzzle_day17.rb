module Day17
  module ShotState
    FLYING = 0
    HIT = 1
    MISS = 2
  end

  class TrickShot
    attr_reader :x_range, :y_range

    def initialize(x_range, y_range)
      correct_order = lambda do |range|
        if range.first < range.last
          range
        else
          Range.new(range.last, range.first)
        end
      end

      @x_range = correct_order[x_range]
      @y_range = correct_order[y_range]
    end

    def shoot(dx, dy)
      Shot.new(dx, dy, x_range, y_range)
      # return to_enum(:shoot, dx, dy) unless block_given?

      # x = 0
      # y = 0

      # loop do
      #   x += dx
      #   y += dy
      #   unless dx.zero?
      #     dx += dx.positive? ? -1 : 1
      #   end
      #   dy -= 1
      #   return if in_target_area?(x, y)

      #   yield x, y
      # end
    end
  end

  class Shot
    attr_reader :x, :y

    def initialize(dx, dy, x_range, y_range)
      @x, @y = 0, 0
      @dx = dx
      @dy = dy
      @x_range = x_range
      @y_range = y_range
      @state = ShotState::FLYING
    end

    def in_target_area?(x, y)
      @x_range.include?(x) && @y_range.include?(y)
    end

    def next
      @x += @dx
      @y += @dy
      @dx = damping(@dx)
      @dy -= 1

      @state = ShotState::HIT if in_target_area?(x, y)

      [x, y]
    end

    def damping(dx)
      return dx if dx.zero?

      dx + (dx.positive? ? -1 : 1)
    end
  end
end
