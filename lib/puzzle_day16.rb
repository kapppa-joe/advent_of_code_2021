# require 'pry'
# require 'pry-byebug'
# require_relative './pry_monkey_patch'

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
        packet = PacketLiteral.new(ver: ver, value: parse_literal_packet_value(stream))
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
      case length_type
      when '0'
        parse_subpackets_type_zero(stream)
      when '1'
        parse_subpackets_type_one(stream)
      else
        # puts(stream.eof?, "<-- this")
        return [] if stream.eof?

        raise 'error encountered when parsing subpackets'
      end
    end

    def parse_subpackets_type_zero(stream)
      subpacket_bits_length = stream.read(15).to_i(2)
      subpacket_bits = stream.read(subpacket_bits_length)
      subpacket_stream = StreamIO.new(subpacket_bits)

      subpackets = []
      subpackets << parse_binary_stream(subpacket_stream, seek_hex_end: false) until subpacket_stream.eof?
      subpackets
    end

    def parse_subpackets_type_one(stream)
      subpacket_count = stream.read(11).to_i(2)
      subpackets = []
      subpackets << parse_binary_stream(stream, seek_hex_end: false) while subpackets.length < subpacket_count
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

    def sum_packet_versions
      raise NotImplementedError
    end
  end

  class PacketOperator < Packet
    attr_reader :subpackets

    def initialize(ver: 0, type: 0)
      super(ver: ver, type: type)
      @subpackets = []
      @subpackets_values = nil
    end

    def add_subpacket(subpacket)
      raise ArgumentError('argument must be of packet class') unless subpacket.is_a?(Packet)

      @subpackets << subpacket
    end

    def [](key)
      @subpackets[key]
    end

    def length
      @subpackets.length
    end

    def sum_packet_versions
      @ver + @subpackets.map(&:sum_packet_versions).sum
    end

    def subpackets_values
      @subpackets_values ||= @subpackets.map(&:value)
    end

    def value
      case @type
      when 0 # sum type
        subpackets_values.sum
      when 1 # product type
        subpackets_values.reduce(&:*)
      when 2 # minimum type
        subpackets_values.min
      when 3
        subpackets_values.max
      when 5, 6, 7
        raise unless subpackets.length == 2

        a, b = subpackets_values
        binary_operator_value(a, b)
      else
        raise NotImplementedError
      end
    end

    def binary_operator_value(a, b)
      case @type
      when 5
        a > b ? 1 : 0
      when 6
        a < b ? 1 : 0
      when 7
        a == b ? 1 : 0
      else
        raise NotImplementedError
      end
    end
  end

  def self.PacketLiteral(ver, value)
    PacketLiteral.new(ver: ver, value: value)
  end

  class PacketLiteral < Packet
    attr_accessor :ver, :type, :value

    def initialize(ver: 0, value: 0)
      super(ver: ver, type: 4)
      @value = value
    end

    def ==(other)
      other.is_a?(PacketLiteral) && @ver == other.ver && @value == other.value
    end

    def sum_packet_versions
      @ver
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  require_relative './utils'
  input_string = read_input_file(16, 'string').first
  decoder = Day16::PacketDecoder.new
  packet = decoder.parse_hex_string(input_string)

  part_a_solution = packet.sum_packet_versions
  puts "solution for part A: #{part_a_solution}"

  part_b_solution = packet.value
  puts "solution for part B: #{part_b_solution}"
end
