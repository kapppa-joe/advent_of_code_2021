module Day16
  class PacketDecoder
    def hex_to_bin(hex_string)
      hex_string.chars.map do |chr|
        chr.to_i(16).to_s(2).rjust(4, '0')
      end.join('')
    end


  end

  class Day16::StreamIO
    attr_accessor :pos

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
  end
end
