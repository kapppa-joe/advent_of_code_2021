require 'puzzle_day22'

describe Day22::ReactorReboot do
  let(:reactor) { described_class.new }

  def cuboid(x:, y:, z:)
    Day22::Cuboid.new(x, y, z)
  end

  day22_smaller_example = [
    'on x=10..12,y=10..12,z=10..12',
    'on x=11..13,y=11..13,z=11..13',
    'off x=9..11,y=9..11,z=9..11',
    'on x=10..10,y=10..10,z=10..10'
  ].freeze

  describe '::parse_input_list' do
    it 'parse an input array of string to reboot steps' do
      input = day22_smaller_example
      expected = [
        { on: true, cuboid: cuboid(x: 10..12, y: 10..12, z: 10..12) },
        { on: true, cuboid: cuboid(x: 11..13, y: 11..13, z: 11..13) },
        { on: false, cuboid: cuboid(x: 9..11, y: 9..11, z: 9..11) },
        { on: true, cuboid: cuboid(x: 10..10, y: 10..10, z: 10..10) }
      ]
      actual = reactor.parse_input_list(input)

      expect(actual).to eq expected
    end
  end
end
