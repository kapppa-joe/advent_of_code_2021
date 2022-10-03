module Day17
  module Status
    FLYING = 0
    HIT = 1
    MISS = 2
  end

  module HelperFunction
    def in_target_area?(x, y)
      @x_range.include?(x) && @y_range.include?(y)
    end
  end

  class TrickShot
    attr_reader :x_range, :y_range

    include HelperFunction

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

    def shoot(dx, dy, hold: true)
      shot = Shot.new(dx, dy, x_range, y_range)
      return shot if hold

      shot.runs_to_end
      shot
    end
  end

  class Shot
    attr_reader :x, :y

    include HelperFunction

    def initialize(dx, dy, x_range, y_range)
      @x, @y = 0, 0
      @dx = dx
      @dy = dy
      @x_range = x_range
      @y_range = y_range
      @state = Status::FLYING
    end

    def next
      @x += @dx
      @y += @dy
      @dx = damping(@dx)
      @dy -= 1
      [x, y]
    end

    def runs_to_end
      while @state == Status::FLYING
        self.next

        if in_target_area?(x, y)
          @state = Status::HIT
        elsif no_hope_to_hit?
          @state = Status::MISS
        end
      end
    end

    def damping(dx)
      return dx if dx.zero?

      dx + (dx.positive? ? -1 : 1)
    end

    def hits?
      raise if @state == Status::FLYING

      @state == Status::HIT
    end

    def no_hope_to_hit?
      # consider x & y separately
      if @dy <= 0 && @y < @y_range.first
        return true
      end

      if @dx.zero?
        return !@x_range.include?(@x)
      elsif @x_range.all?(&:positive?) && @dx.negative?
        return true
      elsif @x_range.all?(&:negative?) && @dx.positive?
        return true
      end

      false
    end
  end
end
