require 'puzzle_day16'

describe Day16::PacketDecoder do
  let(:decoder) { described_class.new }

  describe '::hex_to_bin' do
    test_examples = {
      'D2FE28' => '110100101111111000101000',
      '38006F45291200' => '00111000000000000110111101000101001010010001001000000000',
      'EE00D40C823060' => '11101110000000001101010000001100100000100011000001100000'
    }

    test_examples.each do |input, expected_output|
      it 'convert hex string to binary string' do
        actual = decoder.hex_to_bin(input)
        expect(actual).to eql expected_output
      end
    end
  end

  describe '::parse_binary_stream' do
    it 'can parse a single literal packet' do
      input = Day16::StreamIO.new('110100101111111000101000')
      output = decoder.parse_binary_stream(input)

      expect(output.ver).to eql 6
      expect(output.type).to eql 4
      expect(output.value).to eql 2021
    end
  end
end

describe Day16::StreamIO do
  let(:stream) { described_class.new('00111000000000000110111101000101001010010001001000000000') }

  describe '::read' do
    it 'read n bits of the stream and advance the seeking position' do
      expect(stream.read(3)).to eql '001'
      expect(stream.read(3)).to eql '110'
      expect(stream.read(1)).to eql '0'
      expect(stream.read(15)).to eql '000000000011011'
    end
  end

  describe '::rewind' do
    it 'move the current position n bits backward' do
      stream.read(7)
      stream.rewind(4)
      expect(stream.read(4)).to eql '1100'
      stream.rewind(7)
      expect(stream.read(7)).to eql '0011100'
      expect(stream.read(15)).to eql '000000000011011'
    end
  end
end

describe Day16::Packet do
  let(:packet) { described_class.new }

  it 'contains a version number and a type number' do
    expect(packet.ver).to be_an(Integer)
    expect(packet.type).to be_an(Integer)
  end
end
