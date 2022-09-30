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
      expect(subpackets[0]).to eq Day16::PacketLiteral(6, 10)
      expect(subpackets[1]).to eq Day16::PacketLiteral(2, 20)
    end

    it 'can parse an operator packet of type 1 with subpackets' do
      input = 'EE00D40C823060'
      output = decoder.parse_hex_string(input)
      subpackets = output.subpackets

      expect(subpackets.length).to eql 3
      expect(subpackets[0]).to eq Day16::PacketLiteral(2, 1)
      expect(subpackets[1]).to eq Day16::PacketLiteral(4, 2)
      expect(subpackets[2]).to eq Day16::PacketLiteral(1, 3)
    end
  end

  describe 'Acceptance test' do
    it 'solves the 1st example correctly' do
      input = '8A004A801A8002F478'
      packet = decoder.parse_hex_string(input)

      expect(packet.ver).to eq 4
      expect(packet[0].ver).to eq 1
      expect(packet[0][0].ver).to eq 5
      expect(packet[0][0][0].ver).to eq 6
      expect(packet[0][0][0]).to be_a(Day16::PacketLiteral)

      expect(packet.sum_packet_versions).to eq 16
    end

    it 'solves the 2nd example correctly' do
      input = '620080001611562C8802118E34'
      packet = decoder.parse_hex_string(input)

      expect(packet.ver).to eq 3
      expect(packet[0].length).to eq 2
      expect(packet.sum_packet_versions).to eq 12
    end

    it 'solves the 3rd example correctly' do
      input = 'C0015000016115A2E0802F182340'
      packet = decoder.parse_hex_string(input)

      expect(packet.sum_packet_versions).to eq 23
    end

    it 'solves the 4rd example correctly' do
      input = 'A0016C880162017C3686B18A3D4780'
      packet = decoder.parse_hex_string(input)

      expect(packet[0][0].length).to eq 5
      expect(packet.sum_packet_versions).to eq 31
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
  let(:decoder) { Day16::PacketDecoder.new }

  def build_packet(hex_string)
    decoder.parse_hex_string(hex_string)
  end

  it 'contains a version number and a type number' do
    expect(packet.ver).to be_an(Integer)
    expect(packet.type).to be_an(Integer)
  end

  it 'allows equality check between two literal packets' do
    packet_a = Day16::PacketLiteral(1, 2011)
    packet_b = Day16::PacketLiteral(2, 2011)
    packet_c = Day16::PacketLiteral(1, 2012)
    packet_d = Day16::PacketLiteral(1, 2011)

    expect(packet_a).to eq packet_d
    expect(packet_a).not_to eq packet_b
    expect(packet_a).not_to eq packet_c
  end

  it 'allow accessing subpackets with [] notation' do
    packet = Day16::PacketOperator.new(ver: 1, type: 1)
    packet.add_subpacket(Day16::PacketLiteral(1, 123))
    packet.add_subpacket(Day16::PacketLiteral(2, 456))

    expect(packet[0]).to eq Day16::PacketLiteral(1, 123)
    expect(packet[1]).to eq Day16::PacketLiteral(2, 456)
    expect(packet.length) == 2
  end

  describe '#sum_packet_versions' do
    it 'return the sum of packet versions (including itself and all children packets)' do
      packet = Day16::PacketDecoder.new.parse_hex_string('8A004A801A8002F478')
      expected = 16

      actual_output = packet.sum_packet_versions
      expect(actual_output).to eq expected
    end
  end

  describe 'operator packet compute values' do
    test_cases = [
      { type: 'sum packets', input: 'C200B40A82', expected: 3 },
      { type: 'product packets', input: '04005AC33890', expected: 54 },
      { type: 'minimum packets', input: '880086C3E88112', expected: 7 },
      { type: 'maximum packets', input: 'CE00C43D881120', expected: 9 },
      { type: 'greater than packets', input: 'D8005AC2A8F0', expected: 1 },
      { type: 'less than packets', input: 'F600BC2D8F', expected: 0 },
      { type: 'equal to packets', input: '9C005AC2F8F0', expected: 0 },
      { type: 'combination', input: '9C0141080250320F1802104A08', expected: 1 }
    ]

    test_cases.each do |params|
      it "type: #{params[:type]}" do
        input = params[:input]
        expected = params[:expected]

        actual_output = build_packet(input).value
        expect(actual_output).to eq expected
      end
    end

    # it 'type 0: sum packets' do
    #   input = 'C200B40A82'
    #   expected = 3

    #   actual_output = build_packet(input).value
    #   expect(actual_output).to eq expected
    # end

    # it 'type 1: product packets' do
    #   input = '04005AC33890'
    #   expected = 54

    #   actual_output = build_packet(input).value
    #   expect(actual_output).to eq expected
    # end

    # it 'type 2: minimum packets' do
    #   input = '880086C3E88112'
    #   expected = 7

    #   actual_output = build_packet(input).value
    #   expect(actual_output).to eq expected
    # end
  end
end
