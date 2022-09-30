module Day17
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

    def in_target_area?(x, y)
      @x_range.include?(x) && @y_range.include?(y)
    end

    def shoot(velocity_x, velocity_y)
      return to_enum(:shoot, velocity_x, velocity_y) unless block_given?

      x = 0
      y = 0

      loop do
        x += velocity_x
        y += velocity_y
        unless velocity_x.zero?
          velocity_x += velocity_x.positive? ? -1 : 1
        end
        velocity_y += 1

        yield x, y
      end
    end
  end
end
