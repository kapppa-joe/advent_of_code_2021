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
      shot = trickshot.shoot(7, 2)
      expected = [7, 2]
      actual = shot.next

      expect(actual).to eql expected
    end

    it 'accounts for velocity drag for x' do
      shot = trickshot.shoot(7, 2)

      shot.next

      expect(shot.next[0]).to eql 7 + 6
      expect(shot.next[0]).to eql 7 + 6 + 5
    end

    it 'negative initial velocity of x should approaches 0' do
      shot = trickshot.shoot(-2, 2)

      shot.next

      expect(shot.next[0]).to eql(-2 + -1)
      expect(shot.next[0]).to eql(-2 + -1 + 0)
      expect(shot.next[0]).to eql(-2 + -1 + 0 + 0)
    end

    it 'accounts for gravitational pull for y' do
      shot = trickshot.shoot(7, 2)

      shot.next

      expect(shot.next[1]).to eql 2 + 1
      expect(shot.next[1]).to eql 2 + 1 + 0
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

  describe 'no_hope_to_hit?' do
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
end
