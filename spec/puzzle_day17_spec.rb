require 'puzzle_day17'

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

    it 'stop iteration after the shoot fall within target area' do
      shot = trickshot.shoot(7, 2)
      6.times { shot.next }
      expect { shot.next }.to raise_exception(StopIteration)
    end
  end
end
