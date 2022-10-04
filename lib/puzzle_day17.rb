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
      @x_range = TrickShot.fold_along_y_axis(x_range)
      @y_range = y_range
      @shot_records = {}
    end

    def self.fold_along_y_axis(x_range)
      a, b = x_range.first.abs, x_range.last.abs

      if x_range.include?(0)
        0..([a, b].max)
      else
        a < b ? a..b : b..a
      end
    end

    def max_init_x_speed
      @x_range.max
    end

    def min_init_x_speed
      return 0 if @x_range.include?(0)

      (0..@x_range.min).find { |x0| can_reach_lower_x_range?(x0) }
    end

    def min_init_y_speed
      return @y_range.first if @y_range.first.negative?

      (0..@y_range.min).find { |y0| init_speed_can_reach?(y0, @y_range.min) }
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

    def find_highest_shot_attained_at_given_x(init_x, given_init_y = nil)
      raise 'given init x is out of possible range' if init_x < min_init_x_speed

      if given_init_y.nil? || given_init_y.negative? || !shoot_can_hit?(init_x, given_init_y)
        init_y_to_try = (min_init_y_speed)..(min_init_y_speed.abs * 10)

        valid_init_y = init_y_to_try.find { |init_y| shoot_can_hit?(init_x, init_y) }
        raise 'cannot find a valid y speed for this initial x speed' if valid_init_y.nil?
      else
        valid_init_y = given_init_y
      end

      y_upper_limit_guess = valid_init_y.abs * 2
      y_upper_limit_guess *= 2 while shoot_can_hit?(init_x, y_upper_limit_guess)

      search_range_of_y = y_upper_limit_guess.downto(valid_init_y).to_a
      highest_init_y = search_range_of_y.bsearch { |init_y| shoot_can_hit?(init_x, init_y) }

      shoot(init_x, highest_init_y)
    end

    def max_turns_until_x_velocity_reach_zero
      (0..x_range.last).bsearch { |x| (0..x).sum > x_range.last } - 1
    end

    def init_y_to_reach_height_in_n_turns(target_y, n, includes_just_reach: true)
      if n == 1
        return includes_just_reach ? target_y : target_y + 1
      end

      summation = ->(y) { y.downto(y - n + 1).sum }
      criteria = ->(y) { includes_just_reach ? summation.call(y) >= target_y : summation.call(y) > target_y }
      search_range = target_y.positive? ? (0..(target_y + n)) : (target_y..(target_y.abs + n))
      search_range.bsearch(&criteria)
    end

    def viable_init_y_range_in_n_turns(n)
      lower_limit = init_y_to_reach_height_in_n_turns(y_range.first, n)
      upper_limit = init_y_to_reach_height_in_n_turns(y_range.last, n, includes_just_reach: false) - 1
      lower_limit..upper_limit
    end

    def find_highest_y_position
      raise ArgumentError('target range spans accross 0. highest y position will be infinite') if x_range.include?(0)

      viable_upper_x_limit = max_turns_until_x_velocity_reach_zero
      optimal_turns = viable_upper_x_limit
      viable_y_range = viable_init_y_range_in_n_turns(optimal_turns)
      optimal_shot = find_highest_shot_attained_at_given_x(viable_upper_x_limit, viable_y_range.last)

      viable_upper_x_limit.downto(min_init_x_speed).each do |init_x|
        trial_shot = find_highest_shot_attained_at_given_x(init_x, optimal_shot.init_y)
        optimal_shot = trial_shot if trial_shot.highest_y_position > optimal_shot.highest_y_position
      end

      optimal_shot.highest_y_position
    end

    def valid_y_range_for_given_x(init_x)
      raise 'given init x is out of possible range' if init_x < min_init_x_speed

      a, b = min_init_y_speed, x_range.last
      left = (a..b).find { |init_y| shoot_can_hit?(init_x, init_y) }
      right = b.downto(left).to_a.bsearch { |init_y| shoot_can_hit?(init_x, init_y) }

      left..right
    end

    def find_all_possible_init_velocity
      combinations_to_test = (min_init_x_speed..max_init_x_speed).reduce([]) do |acc, init_x|
        valid_y_range = valid_y_range_for_given_x(init_x)
        acc << [init_x].product(valid_y_range.to_a) if valid_y_range.any?
      rescue ArgumentError
        acc
      end.flatten(1)
      combinations_to_test.filter { |dx, dy| shoot_can_hit?(dx, dy) }
    end
  end

  class Shot
    attr_reader :x, :y, :dx, :dy, :init_y

    include HelperFunction

    def initialize(dx, dy, x_range, y_range)
      @x, @y = 0, 0
      @dx = dx
      @dy = dy
      @init_y = dy
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
  require_relative './utils'
  input_string = read_input_file(17, 'string').first
  input_ranges = input_string.scan(/([-\d]+)/).flatten.map(&:to_i)

  trickshot = Day17::TrickShot.new(input_ranges[0]..input_ranges[1], input_ranges[2]..input_ranges[3])
  part_a_solution = trickshot.find_highest_y_position
  puts "solution for part A: #{part_a_solution}"

  part_b_solution = trickshot.find_all_possible_init_velocity.length
  puts "solution for part B: #{part_b_solution}"

end
