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
      # flip horizontally if x_range is fully on negative side
      x_range = (x_range.last * -1)..(x_range.first * -1) if x_range.first.negative? && !x_range.last.positive?
      @x_range = x_range
      @y_range = y_range
      @shot_records = {}
    end

    def max_init_x_speed
      @x_range.max
    end

    def min_init_x_speed
      return @x_range.first if @x_range.first.negative? && @x_range.last.positive?

      (0..@x_range.min).find { |x0| can_reach_lower_x_range?(x0) }
    end

    def min_init_y_speed
      return @y_range.first if @y_range.first.negative?

      (0..@y_range.min).find { |y0| init_speed_can_reach?(y0, @y_range.min) }
    end

    def speed_range_to_test
      [min_init_x_speed..max_init_x_speed, min_init_y_speed..Float::INFINITY]
    end

    def init_speed_can_reach?(initial_speed, minimum_distance)
      # let a be the initial speed and k be the lower boundary
      # 1 + 2 + ... + a = a * (a + 1) / 2
      # to reach k, a must satisfy a * (a + 1) / 2 >= k
      initial_speed**2 + initial_speed - (2 * minimum_distance) >= 0
    end

    def can_reach_lower_x_range?(x0)
      init_speed_can_reach?(x0, @x_range.first)
    end

    def shoot(dx, dy, hold: false)
      return @shot_records[[dx, dy]] if @shot_records.key?([dx, dy])

      shot = Shot.new(dx, dy, x_range, y_range)
      return shot if hold

      @shot_records[[dx, dy]] = shot
      shot.runs_to_end
      shot
    end

    def shoot_can_hit?(dx, dy)
      return @shot_records[[dx, dy]].hits? if @shot_records.key?([dx, dy])

      shot = shoot(dx, dy, hold: false)
      shot.hits?
    end

    def valid_y_range_for_given_x(init_x)
      raise 'given init x is out of possible range' if init_x < min_init_x_speed

      a, b = min_init_y_speed, x_range.last
      left = (a..b).find { |init_y| shoot_can_hit?(init_x, init_y) }
      right = b.downto(left).to_a.bsearch { |init_y| shoot_can_hit?(init_x, init_y) }

      left..right
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
      @highest_y = 0
      @state = Status::FLYING
    end

    def next
      @x += @dx
      @y += @dy
      @highest_y = [@y, @highest_y].max
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

    def impossible_to_reach_height?
      @dy <= 0 && @y < @y_range.first
    end

    def impossible_to_reach_x?
      @dx.zero? && !@x_range.include?(@x)
    end

    def moving_towards_opposite_x_direction?
      @x_range.all?(&:positive?) && @dx.negative? || @x_range.all?(&:negative?) && @dx.positive?
    end

    def no_hope_to_hit?
      impossible_to_reach_height? || impossible_to_reach_x? || moving_towards_opposite_x_direction?
    end

    def highest_y_position
      @highest_y
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  # trick_shot = Day17::TrickShot.new(20..30, -10..-5)
  trick_shot = Day17::TrickShot.new(-16..9, 43..73)
  # (0..20).each do |dx0|
  dx0 = 2
  (-20..100).each do |dy0|
    shot = trick_shot.shoot(dx0, dy0, hold: false)
    puts "dx: #{dx0}, dy: #{dy0}, max_y: #{shot.highest_y_position} hits?: #{shot.hits?}" if shot.hits?
  end
  # end

  # require_relative './utils'
  # input_string = read_input_file(16, 'string').first
  # decoder = Day16::PacketDecoder.new
  # packet = decoder.parse_hex_string(input_string)

  # part_a_solution = packet.sum_packet_versions
  # puts "solution for part A: #{part_a_solution}"

  # part_b_solution = packet.value
  # puts "solution for part B: #{part_b_solution}"
end
