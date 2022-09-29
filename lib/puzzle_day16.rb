module Day16
  class PacketDecoder
    def hex_to_bin(hex_string)
      hex_string.chars.map do |chr|
        chr.to_i(16).to_s(2).rjust(4, '0')
      end.join('')
    end

    def parse_binary_stream(stream)
      ver = stream.read(3).to_i(2)
      type = stream.read(3).to_i(2)

      if type == 4
        packet = Day16::Packet.new(ver: ver, type: type)
        packet.value = parse_literal_packet_value(stream)
        packet
      end
    end

    def parse_literal_packet_value(stream)
      binary_value = ''
      until stream.eof?
        next_bits = stream.read(5)
        binary_value += next_bits[1..4]
        return binary_value.to_i(2) if next_bits.start_with?('0')
      end
    end
  end

  class Day16::StreamIO
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
  end

  class Day16::Packet
    attr_accessor :ver, :type, :value

    def initialize(ver: 0, type: 0)
      @ver = ver
      @type = type
    end
  end
end
