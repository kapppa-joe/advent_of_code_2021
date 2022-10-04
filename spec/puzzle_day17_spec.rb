require 'puzzle_day17'
require 'pry'

describe Day17::TrickShot do
  let(:trickshot) { described_class.new(20..30, -10..-5) }

  def generate_random_case
    x0, y0 = rand(-50..49), rand(-50..49)
    x1, y1 = x0 + rand(5..50), y0 + rand(5..50)
    described_class.new(x0..x1, y0..y1)
  end

  describe '#in_target_area?' do
    it 'detect whether an (x, y) coordinate is within the given target area' do
      expect(trickshot.in_target_area?(28, -7)).to eq true
      expect(trickshot.in_target_area?(31, -7)).to eq false
      expect(trickshot.in_target_area?(28, -11)).to eq false
    end
  end

  describe '::fold_along_y_axis' do
    test_cases = [
      [20..30, 20..30],
      [-10..-5, 5..10],
      [-10..5, 0..10],
      [-1..10, 0..10]
    ]
    test_cases.each do |input_x_range, expected|
      it 'return the x range folded along y axis' do
        actual = described_class.fold_along_y_axis(input_x_range)

        expect(actual).to eq expected
      end
    end
  end

  describe '#shoot' do
    it 'gives the position after first step correctly' do
      shot = trickshot.shoot(7, 2, hold: true)
      expected = [7, 2]
      actual = shot.next

      expect(actual).to eql expected
    end

    it 'accounts for velocity drag for x' do
      shot = trickshot.shoot(7, 2, hold: true)

      shot.next

      expect(shot.next[0]).to eql 7 + 6
      expect(shot.next[0]).to eql 7 + 6 + 5
    end

    it 'negative initial velocity of x should approaches 0' do
      shot = trickshot.shoot(-2, 2, hold: true)

      shot.next

      expect(shot.next[0]).to eql(-2 + -1)
      expect(shot.next[0]).to eql(-2 + -1 + 0)
      expect(shot.next[0]).to eql(-2 + -1 + 0 + 0)
    end

    it 'accounts for gravitational pull for y' do
      shot = trickshot.shoot(7, 2, hold: true)

      shot.next

      expect(shot.next[1]).to eql 2 + 1
      expect(shot.next[1]).to eql 2 + 1 + 0
    end
  end

  describe '#max_init_x_speed' do
    it 'returns an init x speed that will reach the farest point of target range in 2nd turn' do
      test_cases = {
        [20..30, -10..-5] => 30,
        [10..20, -10..-5] => 20,
        [-10..10, -10..-5] => 10,
        [-30..0, -10..-5] => 30,  # flip horizontally if x range lies fully at negative side
        [-15..15, -10..-5] => 15
      }
      test_cases.each do |params, expected|
        actual = described_class.new(*params).max_init_x_speed
        expect(actual).to eq expected
      end
    end
  end

  describe '#min_init_x_speed' do
    it 'if x_range is both non-negative, returns an init x speed that could reach lower x boundary at some point' do
      test_cases = {
        [6..30, -10..-5] => 3,
        [10..20, -10..-5] => 4,
        [9..10, -10..-5] => 4,
        [11..20, -10..-5] => 5,
        [0..5, -10..-5] => 0
      }
      test_cases.each do |params, expected|
        actual = described_class.new(*params).min_init_x_speed
        expect(actual).to eq expected
      end
    end

    it 'if x_range span from negative to positive, returns 0 (as only consider x_range folded along y-axis)' do
      test_cases = {
        [-6..30, -10..-5] => 0,
        [-10..20, -10..-5] => 0,
        [-5..1, -10..-5] => 0
      }
      test_cases.each do |params, expected|
        actual = described_class.new(*params).min_init_x_speed
        expect(actual).to eq expected
      end
    end
  end

  describe '#min_init_y_speed' do
    it 'when lower y is non-negative, return a minimal init y speed that can reach lower y boundary' do
      test_cases = {
        [0..10, 0..5] => 0,
        [0..10, 3..10] => 2,
        [0..10, 6..10] => 3,
        [0..10, 5..10] => 3,
        [0..10, 7..10] => 4
      }

      test_cases.each do |params, expected|
        actual = described_class.new(*params).min_init_y_speed
        expect(actual).to eq expected
      end
    end

    it 'when lower y is negative, return a lowest init y speed that would just reach lower y at turn 2' do
      test_cases = {
        [0..10, -5..0] => -5,
        [0..10, -3..0] => -3,
        [0..10, -6..0] => -6,
        [0..10, -20..-10] => -20,
        [0..10, -3..7] => -3
      }

      test_cases.each do |params, expected|
        actual = described_class.new(*params).min_init_y_speed
        expect(actual).to eq expected
      end
    end
  end

  describe '#max_turns_until_x_velocity_reach_zero' do
    it 'return the maximum turns until the x velocity drop to 0' do
      expected = 7
      actual = trickshot.max_turns_until_x_velocity_reach_zero

      expect(actual).to eq expected
    end

    describe 'random test' do
      10.times do
        it '' do
          test_shooter = generate_random_case
          output_value = test_shooter.max_turns_until_x_velocity_reach_zero
          validation_shot = test_shooter.shoot(output_value, 9999, hold: true)
          output_value.times { validation_shot.next }
          expect(validation_shot.dx).to be 0
          expect(validation_shot.x).to satisfy('not to shoot through upper x range') { |x|
                                         x <= test_shooter.x_range.last
                                       }
        end
      end
    end
  end

  describe '#init_y_to_reach_height_in_n_turns' do
    describe 'return an initial y velocity, given a height target_y and turn number n' do
      it 'basic example' do
        input_target_y = 20
        turn_number = 3
        expected = 8
        actual = trickshot.init_y_to_reach_height_in_n_turns(input_target_y, turn_number)

        expect(actual).to eq expected
      end

      it 'basic example 2' do
        input_target_y = 30
        turn_number = 6
        expected = 8
        actual = trickshot.init_y_to_reach_height_in_n_turns(input_target_y, turn_number)

        expect(actual).to eq expected
      end

      it 'basic example 3' do
        input_target_y = 100
        turn_number = 10
        expected = 15
        actual = trickshot.init_y_to_reach_height_in_n_turns(input_target_y, turn_number)

        expect(actual).to eq expected
      end

      it 'handle turn_number = 1 correctly' do
        input_target_y = 20
        turn_number = 1
        expected = 20
        actual = trickshot.init_y_to_reach_height_in_n_turns(input_target_y, turn_number)

        expect(actual).to eq expected
      end

      it 'test case for negative target y' do
        input_target_y = -10
        turn_number = 7
        expected = 2
        actual = trickshot.init_y_to_reach_height_in_n_turns(input_target_y, turn_number)

        expect(actual).to eq expected
      end

      it 'another test case for negative target y' do
        input_target_y = -20
        turn_number = 3
        expected = -5
        actual = trickshot.init_y_to_reach_height_in_n_turns(input_target_y, turn_number)

        expect(actual).to eq expected
      end
    end
  end

  describe '#viable_init_y_range_in_n_turns' do
    describe 'return a range of initial y velocity that will arrive at designated y range at exactly n turns' do
      it 'basic example' do
        y_range = 20..30
        turn_number = 3
        expected = 8..11
        actual = described_class.new(0..0, y_range).viable_init_y_range_in_n_turns(turn_number)

        expect(actual).to eq expected
      end

      it 'another example' do
        y_range = 43..73
        turn_number = 9
        expected = 9..12
        actual = described_class.new(0..0, y_range).viable_init_y_range_in_n_turns(turn_number)

        expect(actual).to eq expected
      end

      it 'handle case of turn number = 1 correctly' do
        y_range = 10..20
        turn_number = 1
        expected = 10..20
        actual = described_class.new(0..0, y_range).viable_init_y_range_in_n_turns(turn_number)

        expect(actual).to eq expected
      end

      it 'test case for negative y' do
        y_range = -105..-57
        turn_number = 4
        expected = Range.new(-24, -13)
        actual = described_class.new(0..0, y_range).viable_init_y_range_in_n_turns(turn_number)

        expect(actual).to eq expected
      end
    end

    describe 'random test' do
      it '' do
        10.times do
          test_shooter = generate_random_case
          turn_number = rand(1..5)
          output_y_range = test_shooter.viable_init_y_range_in_n_turns(turn_number)
          left, right = output_y_range.first, output_y_range.last
          expect([left, right]).to all(satisfy('arrive within y range on the nth turn') do |init_y|
            y_position_at_nth_turn = init_y.downto(init_y - turn_number + 1).sum
            test_shooter.y_range.include?(y_position_at_nth_turn)
          end)

          expect([left - 1, right + 1]).to all(satisfy('fall out of y range on the nth turn') do |init_y|
            y_position_at_nth_turn = init_y.downto(init_y - turn_number + 1).sum
            !test_shooter.y_range.include?(y_position_at_nth_turn)
          end)
        end
      end
    end
  end

  describe '#find_highest_shot_attained_at_given_x' do
    it 'return the shot that attained the highest y position at a given initial x speed' do
      input_init_x = 7
      actual = trickshot.find_highest_shot_attained_at_given_x(input_init_x)
      expect(actual.highest_y_position).to eq 45
    end

    it 'another test case' do
      trickshot = described_class.new(-16..9, 43..73)
      input_init_x = 3
      actual = trickshot.find_highest_shot_attained_at_given_x(input_init_x)
      expect(actual.highest_y_position).to eq 73
    end
  end

  describe '#find_highest_y_position' do
    it 'returns the highest y position that can be reach by the target range' do
      expected = 45
      actual = trickshot.find_highest_y_position

      expect(actual).to eq expected
    end

    it 'can handle another test case' do
      trickshot = described_class.new(100..137, 43..73)
      expected = 2701

      actual = trickshot.find_highest_y_position
      expect(actual).to eq expected
    end

    it 'more complex test_case' do
      trickshot = described_class.new(200..250, -105..-57)
      expected = 5460

      actual = trickshot.find_highest_y_position
      expect(actual).to eq expected
    end
  end

  describe '#find_all_possible_init_velocity return a collection of all init velocity that hits the target range' do
    it 'basic example' do
      expected = 112
      actual = trickshot.find_all_possible_init_velocity.length

      expect(actual).to eq expected
    end

    describe 'random test' do
      10.times do
        it '' do
          test_shooter = generate_random_case
          actual = test_shooter.find_all_possible_init_velocity
          expect(actual).to all(satisfy('hits the target range') do |dx, dy|
            test_shooter.shoot_can_hit?(dx, dy)
          end)
        end
      end
    end
  end
end

describe Day17::Shot do
  let(:trickshot) { Day17::TrickShot.new(20..30, -10..-5) }
  let(:sample_shot) { trickshot.shoot(7, 2, hold: false) }

  describe '#hits?' do
    it 'returns true if the shoot hits target range' do
      expect(sample_shot.hits?).to eq true
    end

    it '2nd example' do
      shot = trickshot.shoot(6, 3, hold: false)
      expect(shot.hits?).to eq true
    end

    it '3rd example' do
      shot = trickshot.shoot(9, 0, hold: false)
      expect(shot.hits?).to eq true
    end

    it 'falsey example' do
      shot = trickshot.shoot(17, -4, hold: false)
      expect(shot.hits?).to eq false
    end
  end

  describe '#no_hope_to_hit?' do
    truthy_test_cases = [
      { x_range: 20..30, y_range: -10..-5, dx: 0, dy: 0 },  # not moving forward
      { x_range: 20..30, y_range: -10..-5, dx: -5, dy: 0 }, # moving towards opposite x direction
      { x_range: -5..5, y_range: 5..10, dx: 0, dy: 1 }, # cannot reach the height
      { x_range: -5..5, y_range: -5..5, dx: 0, dy: -6 }, # fall below target range
      { x_range: 5..10, y_range: -10..-5, dx: 2, dy: 2 }, # barely miss the target
      { x_range: 5..10, y_range: 4..10, dx: 3, dy: 2 } # barely miss the target
    ]

    falsey_test_cases = [
      { x_range: -5..5, y_range: -10..-5, dx: 0, dy: 5 }, # can arrive by just falling downward
      { x_range: -5..5, y_range: 5..10, dx: 0, dy: 3 }, # can reach the height
      { x_range: 5..10, y_range: -10..-5, dx: 3, dy: 2 } # can barely reach the target
    ]

    test_cases = truthy_test_cases.product([true]) + falsey_test_cases.product([false])

    test_cases.each do |params, expected|
      it "detects if a shoot has no hope to hit the target range, params: #{params}, expected: #{expected}" do
        shot = described_class.new(params[:dx], params[:dy], params[:x_range], params[:y_range])
        shot.runs_to_end
        expect(shot.no_hope_to_hit?).to eq expected
      end
    end
  end

  describe '#highest_y_position' do
    it 'return the highest y coordinate attained so far' do
      test_cases = {
        [7, 2] => 3,
        [6, 3] => 6,
        [9, 0] => 0,
        [17, -4] => 0
      }
      test_cases.each do |params, expected|
        actual = trickshot.shoot(*params, hold: false).highest_y_position
        expect(actual).to eq expected
      end
    end
  end
end
