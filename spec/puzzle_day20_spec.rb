require 'puzzle_day20'

describe Day20::TrenchMap do
  let(:trench_map) { described_class.new }

  example_algorithm = %w[
    ..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..##
    #..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###
    .######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#.
    .#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#.....
    .#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#..
    ...####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.....
    ..##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#
  ].join('')

  example_image = %w[
    #..#.
    #....
    ##..#
    ..#..
    ..###
  ]

  describe '::parse_enhance_algorithm' do
    it 'convert enhance algorithm string into a hash' do
      input_string = '..#..#'
      expected = {
        2 => true,
        5 => true
      }

      actual = trench_map.parse_enhance_algorithm(input_string)

      expect(actual).to eq expected
    end

    it 'parse the example correctly' do
      input_string = example_algorithm

      output = trench_map.parse_enhance_algorithm(input_string)

      expect(output[33]).to eq false
      expect(output[34]).to eq true
      expect(output[35]).to eq true
      expect(output[511]).to eq true
    end
  end

  describe '::parse_image' do
    it 'convert the input image into a hash of coords' do
      input = example_image

      expected = {
        [0, 0] => true,
        [3, 0] => true,
        [0, 1] => true,
        [0, 2] => true,
        [1, 2] => true,
        [4, 2] => true,
        [2, 3] => true,
        [2, 4] => true,
        [3, 4] => true,
        [4, 4] => true
      }
      actual = trench_map.parse_image(input)

      expect(actual).to eq expected
      expect(actual[[1, 1]]).to eq false
    end
  end

  describe '#binary_num_from_image' do
    it 'extract binary number from a coordinate of an image' do
      input_image = trench_map.parse_image(example_image)
      input_coord = [2, 2]
      expected = 34

      actual = trench_map.binary_num_from_image(input_image, *input_coord)

      expect(actual).to eq expected
    end
  end

  describe '#display_image' do
    it 'convert image hash to a ASCII representation of image' do
      input = trench_map.parse_image(example_image)
      expected = example_image

      actual = trench_map.display_image(input)

      expect(actual).to eq expected
    end
  end

  describe '#enhance_image' do
    it 'enhance the example image correctly' do
      input_image = trench_map.parse_image(example_image)
      input_algorithm = trench_map.parse_enhance_algorithm(example_algorithm)
      expected = %w[
        .##.##.
        #..#.#.
        ##.#..#
        ####..#
        .#..##.
        ..##..#
        ...#.#.
      ]

      output = trench_map.enhance(input_image, input_algorithm)
      output_in_ascii_form = trench_map.display_image(output)

      expect(output_in_ascii_form).to eq expected
    end

    it 'enhance the second time correctly' do
      input_image = trench_map.parse_image(example_image)
      input_algorithm = trench_map.parse_enhance_algorithm(example_algorithm)
      expected = %w[
        .......#.
        .#..#.#..
        #.#...###
        #...##.#.
        #.....#.#
        .#.#####.
        ..#.#####
        ...##.##.
        ....###..
      ]

      after_first_enhance = trench_map.enhance(input_image, input_algorithm)
      after_second_enhance = trench_map.enhance(after_first_enhance, input_algorithm) 
      output_in_ascii_form = trench_map.display_image(after_second_enhance)

      expect(output_in_ascii_form).to eq expected
    end

    it 'can handle infinite image correctly' do
      input_image = trench_map.parse_image(example_image)
      input_algorithm = trench_map.parse_enhance_algorithm(example_algorithm)
      input_algorithm[0] = true

      output = trench_map.enhance(input_image, input_algorithm)

      expect(output[[-10, -10]]).to eq true
      expect(output[[100, 100]]).to eq true
    end

    it 'calculate enhance 50 times of the example case correctly' do
      input_image = trench_map.parse_image(example_image)
      input_algorithm = trench_map.parse_enhance_algorithm(example_algorithm)

      expected = 3351

      output = 50.times.reduce(input_image) { |img| trench_map.enhance(img, input_algorithm) }
      actual = trench_map.count_lit_pixels(output)

      expect(actual).to eq expected
    end
  end

  describe '#count_lit_pixel' do
    it 'counts the number of light pixel in an image' do
      input_image = trench_map.parse_image(example_image)
      input_algorithm = trench_map.parse_enhance_algorithm(example_algorithm)
      after_first_enhance = trench_map.enhance(input_image, input_algorithm)
      after_second_enhance = trench_map.enhance(after_first_enhance, input_algorithm) 

      expected = 35
      actual = trench_map.count_lit_pixels(after_second_enhance)
      expect(actual).to eq 35
    end
  end
end
