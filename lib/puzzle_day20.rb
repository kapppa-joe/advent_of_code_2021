module Day20
  class TrenchMap
    LIGHT_PIXEL = '#'.freeze
    DARK_PIXEL = '.'.freeze

    def light_pixel?(char)
      char == LIGHT_PIXEL
    end

    def parse_enhance_algorithm(input_string)
      input_string.chars.each_with_index.reduce(Hash.new(false)) do |hash, char_and_index|
        char, index = char_and_index
        hash[index] = true if light_pixel?(char)
        hash
      end
    end

    def parse_image(input_array)
      hash = Hash.new(false)
      input_array.each.with_index do |row, y|
        row.chars.each_with_index do |pixel, x|
          hash[[x, y]] = true if light_pixel?(pixel)
        end
      end
      hash
    end

    def parse_input(input_array)
      algorithm = parse_enhance_algorithm(input_array[0])

      image = parse_image(input_array[2..])

      [algorithm, image]
    end

    def binary_num_from_image(image, x, y)
      pixel_coords = [y - 1, y, y + 1].flat_map do |y_coord|
        [x - 1, x, x + 1].map do |x_coord|
          [x_coord, y_coord]
        end
      end

      nine_pixel_values = pixel_coords.map { |coord| image[coord] ? 1 : 0 }

      nine_pixel_values.reduce(0) { |acc, bit| acc * 2 + bit }
    end

    def display_image(image)
      min_x, max_x = image.keys.map { |x, _y| x }.minmax
      min_y, max_y = image.keys.map { |_x, y| y }.minmax

      (min_y..max_y).map do |y|
        (min_x..max_x).map { |x| image[[x, y]] ? LIGHT_PIXEL : DARK_PIXEL }.join('')
      end
    end

    def enhance(image, algorithm)
      min_x, max_x = image.keys.map { |x, _y| x }.minmax
      min_y, max_y = image.keys.map { |_x, y| y }.minmax
      min_x -= 1
      min_y -= 1
      max_x += 1
      max_y += 1

      new_default = image.default
      new_default = !new_default if algorithm[0] == true

      new_image = Hash.new(new_default)
      (min_x..max_x).each do |x|
        (min_y..max_y).each do |y|
          value = binary_num_from_image(image, x, y)
          new_image[[x, y]] = algorithm[value]
        end
      end

      new_image
    end

    def count_lit_pixels(image)
      return Float::INFINITY if image.default == true

      image.values.count(true)
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  require_relative './utils'
  input_array = read_input_file(20, 'string')
  trench_map = Day20::TrenchMap.new
  algorithm, image = trench_map.parse_input(input_array)

  enhanced_two_times = 2.times.reduce(image) { |img| trench_map.enhance(img, algorithm) }
  part_a_solution = trench_map.count_lit_pixels(enhanced_two_times)
  puts "solution for part A: #{part_a_solution}"

  enhanced_50_times = 50.times.reduce(image) { |img| trench_map.enhance(img, algorithm) }
  part_b_solution = trench_map.count_lit_pixels(enhanced_50_times)
  puts "solution for part B: #{part_b_solution}"

end
