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

    it 'consumes the place filling zeros at the end correctly' do
      input = Day16::StreamIO.new('1101001011111110001010001111')
      decoder.parse_binary_stream(input)

      expect(input.pos).to eql 24
    end
  end

  describe '::parse_hex_string' do
    it 'can parse a single literal packet' do
      input = 'D2FE28'
      output = decoder.parse_hex_string(input)

      expect(output.ver).to eql 6
      expect(output.type).to eql 4
      expect(output.value).to eql 2021
    end

    it 'can parse an operator packet' do
      input = '38006F45291200'
      output = decoder.parse_hex_string(input)

      expect(output.ver).to eql 1
      expect(output.type).to eql 6
    end
  end

  describe 'parsing nested packets' do
    it 'can parse an operator packet of type 0 with subpackets' do
      input = '38006F45291200'
      output = decoder.parse_hex_string(input)
      subpackets = output.subpackets

      expect(subpackets.length).to eql 2
      expect(subpackets[0]).to eq Day16::PacketLiteral(6, 4, 10)
      expect(subpackets[1]).to eq Day16::PacketLiteral(2, 4, 20)
    end

    xit 'can parse an operator packet of type 1 with subpackets' do
      input = 'EE00D40C823060'
      output = decoder.parse_hex_string(input)
      subpackets = output.subpackets

      expect(subpackets.length).to eql 3
      # expect(subpackets[0]).to eq Day16::PacketLiteral(6, 4, 10)
      # expect(subpackets[1]).to eq Day16::PacketLiteral(2, 4, 20)
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

  it 'allows equality check between two literal packets' do
    packet_a = Day16::PacketLiteral(1, 1, 2011)
    packet_b = Day16::PacketLiteral(2, 1, 2011)
    packet_c = Day16::PacketLiteral(1, 2, 2011)
    packet_d = Day16::PacketLiteral(1, 1, 2012)
    packet_e = Day16::PacketLiteral(1, 1, 2011)

    expect(packet_a).to eq packet_e
    expect(packet_a).not_to eq packet_b
    expect(packet_a).not_to eq packet_c
    expect(packet_a).not_to eq packet_d
  end
end
