module Day22
  Cuboid = Struct.new(:x, :y, :z)

  class ReactorReboot
    def parse_input_list(input_array)
      input_array.map do |line|
        type, *coords = line.scan(/on|off|\d+/)
        x, y, z = coords.map(&:to_i).each_slice(2).map { |pair| Range.new(*pair) }
        cuboid = Cuboid.new(x, y, z)
        { on: type == 'on',cuboid: cuboid }
      end
    end
  end
end
