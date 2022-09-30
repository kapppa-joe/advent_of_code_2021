require 'pry'

module Day16
  class PacketDecoder
    def hex_to_bin(hex_string)
      hex_string.chars.map do |chr|
        chr.to_i(16).to_s(2).rjust(4, '0')
      end.join('')
    end

    def parse_hex_string(hex_string)
      stream = Day16::StreamIO.new(hex_to_bin(hex_string))
      parse_binary_stream(stream)
    end

    def parse_binary_stream(stream, seek_hex_end: true)
      ver = stream.read(3).to_i(2)
      type = stream.read(3).to_i(2)

      if type == 4
        packet = PacketLiteral.new(ver: ver, type: type, value: parse_literal_packet_value(stream))
      else
        packet = PacketOperator.new(ver: ver, type: type)
        parse_subpackets(stream).each { |subpacket| packet.add_subpacket(subpacket) }
      end
      stream.seek_to_next_hex if seek_hex_end
      packet
    end

    def parse_literal_packet_value(stream)
      binary_value = ''
      until stream.eof?
        next_bits = stream.read(5)
        binary_value += next_bits[1..4]
        return binary_value.to_i(2) if next_bits.start_with?('0')
      end
    end

    def parse_subpackets(stream)
      length_type = stream.read(1)
      raise NotImplementedError if length_type == '1'

      subpacket_bits_length = stream.read(15).to_i(2)
      subpacket_bits = stream.read(subpacket_bits_length)
      subpacket_stream = StreamIO.new(subpacket_bits)

      subpackets = []
      subpackets << parse_binary_stream(subpacket_stream, seek_hex_end: false) until subpacket_stream.eof?
      subpackets
    end
  end

  class StreamIO
    attr_reader :pos

    def initialize(str)
      @string = str
      @pos = 0
    end

    def read(num)
      raise if num.negative?

      bits = @string.slice(@pos, num)
      @pos += num
      bits
    end

    def rewind(num)
      raise if num > @pos || num.negative?

      @pos -= num
    end

    def eof?
      @pos >= @string.length
    end

    def seek_to_next_hex
      @pos += (4 - @pos % 4) if @pos % 4 != 0
    end
  end

  class Packet
    attr_accessor :ver, :type

    def initialize(ver: 0, type: 0)
      @ver = ver
      @type = type
    end
  end

  class PacketOperator < Packet
    attr_reader :subpackets

    def initialize(ver: 0, type: 0)
      super(ver: ver, type: type)
      @subpackets = []
    end

    def add_subpacket(subpacket)
      raise ArgumentError('argument must be of packet class') unless subpacket.is_a?(Packet)

      @subpackets << subpacket
    end
  end

  def self.PacketLiteral(ver, type, value)
    PacketLiteral.new(ver: ver, type: type, value: value)
  end

  class PacketLiteral < Packet
    attr_accessor :ver, :type, :value

    def initialize(ver: 0, type: 0, value: 0)
      super(ver: ver, type: type)
      @value = value
    end

    def ==(other)
      other.is_a?(PacketLiteral) && @ver == other.ver && @type == other.type && @value == other.value
    end
  end
end
