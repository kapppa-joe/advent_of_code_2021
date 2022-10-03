require 'puzzle_day17'
require 'pry'

describe Day17::TrickShot do
  let(:trickshot) { described_class.new(20..30, -10..-5) }
  describe '#in_target_area?' do
    it 'detect whether an (x, y) coordinate is within the given target area' do
      expect(trickshot.in_target_area?(28, -7)).to eq true
      expect(trickshot.in_target_area?(31, -7)).to eq false
      expect(trickshot.in_target_area?(28, -11)).to eq false
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
        [-15..10, -10..-5] => 10
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

    it 'if x_range span from negative to positive, returns an init x speed that could reach lower x boundary at 2nd turn' do
      test_cases = {
        [-6..30, -10..-5] => -6,
        [-10..20, -10..-5] => -10,
        [-5..1, -10..-5] => -5
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

  describe '#valid_y_range_for_given_x returns a valid range of init y' do
    describe 'preset cases' do
      it 'basic case [20..30, -10..-5], x = 7' do
        actual = trickshot.valid_y_range_for_given_x(7)
        expect(actual).to eq Range.new(-1, 9)
      end

      it 'basic case [20..30, -10..-5], x = 9' do
        actual = trickshot.valid_y_range_for_given_x(9)
        expect(actual).to eq Range.new(-2, 0)
      end

      it 'basic case [20..30, -10..-5], x = 6' do
        actual = trickshot.valid_y_range_for_given_x(6)
        expect(actual).to eq 0..9
      end

      it 'test case [-16..9, 43..73], x = 2' do
        test_trickshot = Day17::TrickShot.new(-16..9, 43..73)
        actual = test_trickshot.valid_y_range_for_given_x(2)
        expect(actual).to eq 9..73
      end
    end

    xdescribe 'random tests' do
      x0, y0 = rand(100) - 50, rand(100) - 50
      x1, y1 = x0 + rand(50), y0 + rand(50)
      it "returns correct range for random params: #{[x0..x1, y0..y1]}" do
        test_trickshot = Day17::TrickShot.new(x0..x1, y0..y1)
        min_init_x = test_trickshot.min_init_x_speed
        max_init_x = test_trickshot.max_init_x_speed
        init_x = min_init_x + rand(max_init_x - min_init_x)

        result = test_trickshot.valid_y_range_for_given_x(init_x)
        lower_y, upper_y = result.first, result.last

        validate_shooter = Day17::TrickShot.new(x0..x1, y0..y1)
        expect(validate_shooter.shoot(init_x, lower_y).hits?).to eq true
        expect(validate_shooter.shoot(init_x, upper_y).hits?).to eq true
      end
    end
  end

  # xdescribe 'For any valid target range, the set of max init x and min init y should guaranteed to hit' do
  #   describe 'preset test cases' do
  #     test_cases = [
  #       [20..30, -10..-5],
  #       [10..20, 20..30],
  #       [-5..10, -10..-5],
  #       [-20..-10, 2..10],
  #       [5..5, 10..10]
  #     ]
  #     test_cases.each do |params|
  #       it "params: #{params}" do
  #         trick_shot = described_class.new(*params)
  #         max_x, min_y = trick_shot.max_init_x_speed, trick_shot.min_init_y_speed
  #         shot = trick_shot.shoot(max_x, min_y)
  #         puts shot.inspect
  #         shot.runs_to_end
  #         expect(shot.hits?).to be true
  #       end
  #     end
  #   end
  # end
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
