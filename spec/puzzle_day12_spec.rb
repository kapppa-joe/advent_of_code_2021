require 'puzzle_day12'

day12_basic_example = %w[
  start-A
  start-b
  A-c
  A-b
  b-d
  A-end
  b-end
]

day12_larger_example = %w[
  dc-end
  HN-start
  start-kj
  dc-start
  dc-HN
  LN-dc
  HN-end
  kj-sa
  kj-HN
  kj-dc
]

day12_even_larger_example = %w[
  fs-end
  he-DX
  fs-he
  start-DX
  pj-DX
  end-zg
  zg-sl
  zg-pj
  pj-he
  RW-he
  fs-DX
  pj-RW
  zg-RW
  start-pj
  he-WI
  zg-he
  pj-fs
  start-RW
]

describe Day12::PassagePathing do
  let(:passage) { described_class.new(day12_basic_example) }

  describe '#make_graph' do
    it 'return an empty hash when given an empty array' do
      input = []
      expected_output = {}

      expect(passage.make_graph(input)).to eql expected_output
    end

    it 'return a graph with two nodes when given an array with string start-A' do
      input = ['start-A']
      expected_output = {
        'start' => ['A'],
        'A' => ['start']
      }

      expect(passage.make_graph(input)).to eql expected_output
    end

    it 'parse the input arrays into a graph represented by hash dict' do
      input = day12_basic_example
      expected_output = {
        'start' => %w[A b],
        'A' => %w[start c b end],
        'b' => %w[start A d end],
        'c' => ['A'],
        'd' => ['b'],
        'end' => %w[A b]
      }

      expect(passage.make_graph(input)).to eql expected_output
    end
  end

  describe '#search_paths' do
    context 'basic rules' do
      it 'returns one path when given a graph with only two nodes and one edge' do
        input = ['start-end']
        expected_output = ['start,end']

        passage = described_class.new(input)
        expect(passage.search_paths).to eql expected_output
      end

      it 'returns an empty array when end node is not connected to anywhere' do
        input = ['start-A']
        expected_output = []

        passage = described_class.new(input)
        expect(passage.search_paths).to eql expected_output
      end

      it 'can search through a one way path from start to end consist of three nodes' do
        input = %w[start-A A-end]
        expected_output = ['start,A,end']

        passage = described_class.new(input)
        expect(passage.search_paths).to eql expected_output
      end

      it 'does not visit a small cave twice' do
        input = %w[start-a a-end]
        visited = ['a']
        expected_output = []

        passage = described_class.new(input)
        expect(passage.search_paths(visited: visited)).to eql expected_output
      end

      it 'can visit a large cave twice' do
        input = %w[start-A A-end]
        visited = ['A']
        expected_output = ['A,start,A,end']

        passage = described_class.new(input)
        expect(passage.search_paths(visited: visited)).to eql expected_output
      end

      it 'can search a graph with more than one possible route' do
        input = %w[start-A start-B A-end B-end]
        expected_output = [
          'start,A,end',
          'start,B,end'
        ]

        passage = described_class.new(input)
        expect(passage.search_paths).to eql expected_output
      end
    end

    context 'test cases' do
      it 'solves the basic example correctly' do
        expected_output = %w[
          start,A,b,A,c,A,end
          start,A,b,A,end
          start,A,b,end
          start,A,c,A,b,A,end
          start,A,c,A,b,end
          start,A,c,A,end
          start,A,end
          start,b,A,c,A,end
          start,b,A,end
          start,b,end
        ]

        passage = described_class.new(day12_basic_example)
        expect(passage.search_paths).to match_array expected_output
      end

      it 'solves the larger example correctly' do
        expected_output = %w[
          start,HN,dc,HN,end
          start,HN,dc,HN,kj,HN,end
          start,HN,dc,end
          start,HN,dc,kj,HN,end
          start,HN,end
          start,HN,kj,HN,dc,HN,end
          start,HN,kj,HN,dc,end
          start,HN,kj,HN,end
          start,HN,kj,dc,HN,end
          start,HN,kj,dc,end
          start,dc,HN,end
          start,dc,HN,kj,HN,end
          start,dc,end
          start,dc,kj,HN,end
          start,kj,HN,dc,HN,end
          start,kj,HN,dc,end
          start,kj,HN,end
          start,kj,dc,HN,end
          start,kj,dc,end
        ]

        passage = described_class.new(day12_larger_example)
        expect(passage.search_paths).to match_array expected_output
      end

      it 'count the number of paths in the even larger example correctly' do
        expected_length = 226

        passage = described_class.new(day12_even_larger_example)
        expect(passage.search_paths.length).to eql expected_length
      end
    end
  end
end

describe Day12::PassagePathingWithSecondVisit do
  let(:passage) { described_class.new(day12_basic_example) }

  describe '#possible_next_nodes' do
    it 'include a small cave in return array if visited 0 times' do
      next_nodes = %w[a B]
      visited = []
      expected_output = %w[a B]

      actual_output = passage.possible_next_nodes(next_nodes, visited)
      expect(actual_output).to eql expected_output
    end

    it 'exclude a small cave in return array if visited 2 times' do
      next_nodes = %w[a B]
      visited = %w[a a]
      expected_output = ['B']

      actual_output = passage.possible_next_nodes(next_nodes, visited)
      expect(actual_output).to eql expected_output
    end

    it 'include a small cave in return array if visited 1 times' do
      next_nodes = %w[a B]
      visited = ['a']
      expected_output = %w[a B]

      actual_output = passage.possible_next_nodes(next_nodes, visited)
      expect(actual_output).to eql expected_output
    end

    it 'exclude start in return array even if it was not visited' do
      next_nodes = %w[start a B]
      visited = []
      expected_output = %w[a B]

      actual_output = passage.possible_next_nodes(next_nodes, visited)
      expect(actual_output).to eql expected_output
    end

    it 'exclude start in return array when it was visited once' do
      next_nodes = %w[start a B]
      visited = ['start']
      expected_output = %w[a B]

      actual_output = passage.possible_next_nodes(next_nodes, visited)
      expect(actual_output).to eql expected_output
    end

    it 'include a large cave even if already visited once' do
      next_nodes = %w[start a B]
      visited = %w[start a a B]
      expected_output = ['B']

      actual_output = passage.possible_next_nodes(next_nodes, visited)
      expect(actual_output).to eql expected_output
    end

    it 'include a large cave even if visited many time' do
      next_nodes = %w[start a B]
      visited = %w[start a B a B B]
      expected_output = ['B']

      actual_output = passage.possible_next_nodes(next_nodes, visited)
      expect(actual_output).to eql expected_output
    end

    context 'if alredy visited a small cave twice' do
      it 'can still visit a small cave if it was not visited yet' do
        next_nodes = %w[start a c B]
        visited = %w[start a B a]
        expected_output = %w[c B]

        actual_output = passage.possible_next_nodes(next_nodes, visited)
        expect(actual_output).to eql expected_output
      end

      it 'will not allow a second visit to any small cave' do
        next_nodes = %w[start aa cc B]
        visited = %w[start aa B cc aa]

        expected_output = ['B']

        actual_output = passage.possible_next_nodes(next_nodes, visited)
        expect(actual_output).to eql expected_output
      end
    end
  end

  describe '#search_paths' do
    it 'can visit a small cave twice' do
      input = %w[start-a a-b a-end]
      expected_output = [
        'start,a,end',
        'start,a,b,a,end'
      ]
      passage = described_class.new(input)
      actual_output = passage.search_paths
      expect(actual_output).to match_array expected_output
    end

    it 'can visit a large cave many time' do
      input = %w[start-a a-b a-end]
      expected_output = [
        'start,a,end',
        'start,a,b,a,end'
      ]
      passage = described_class.new(input)
      actual_output = passage.search_paths
      expect(actual_output).to match_array expected_output
    end

    it 'can visit a single small cave twice' do
      input = %w[start-a a-C C-end start-b b-C]
      expected_output = %w[
        start,a,C,end
        start,a,C,a,C,end
        start,a,C,a,C,b,C,end
        start,a,C,b,C,end
        start,a,C,b,C,a,C,end
        start,a,C,b,C,b,C,end
        start,b,C,end
        start,b,C,b,C,end
        start,b,C,b,C,a,C,end
        start,b,C,a,C,end
        start,b,C,a,C,b,C,end
        start,b,C,a,C,a,C,end
      ]

      passage = described_class.new(input)
      actual_output = passage.search_paths
      expect(actual_output).to match_array expected_output
    end

    it 'will exclude a path which include visiting two small caves each twice' do
      input = %w[
        start-kj
        dc-start
        HN-start
        kj-HN
        kj-dc
        dc-end
      ]
      passage = described_class.new(input)
      path_not_allowed = 'start,HN,kj,dc,kj,dc,end'
      actual_output = passage.search_paths
      expect(actual_output).not_to include(path_not_allowed)

    end

    it 'solves the basic example correctly' do
      input = day12_basic_example
      expected_output = %w[
        start,A,b,A,b,A,c,A,end
        start,A,b,A,b,A,end
        start,A,b,A,b,end
        start,A,b,A,c,A,b,A,end
        start,A,b,A,c,A,b,end
        start,A,b,A,c,A,c,A,end
        start,A,b,A,c,A,end
        start,A,b,A,end
        start,A,b,d,b,A,c,A,end
        start,A,b,d,b,A,end
        start,A,b,d,b,end
        start,A,b,end
        start,A,c,A,b,A,b,A,end
        start,A,c,A,b,A,b,end
        start,A,c,A,b,A,c,A,end
        start,A,c,A,b,A,end
        start,A,c,A,b,d,b,A,end
        start,A,c,A,b,d,b,end
        start,A,c,A,b,end
        start,A,c,A,c,A,b,A,end
        start,A,c,A,c,A,b,end
        start,A,c,A,c,A,end
        start,A,c,A,end
        start,A,end
        start,b,A,b,A,c,A,end
        start,b,A,b,A,end
        start,b,A,b,end
        start,b,A,c,A,b,A,end
        start,b,A,c,A,b,end
        start,b,A,c,A,c,A,end
        start,b,A,c,A,end
        start,b,A,end
        start,b,d,b,A,c,A,end
        start,b,d,b,A,end
        start,b,d,b,end
        start,b,end
      ]

      actual_output = described_class.new(input).search_paths
      expect(actual_output).to match_array expected_output
    end

    it 'solves the larger example correctly' do
      input = day12_larger_example
      expected_length = 103

      actual_length = described_class.new(input).search_paths.length
      expect(actual_length).to eql expected_length
    end

    it 'solves the even larger example correctly' do
      input = day12_even_larger_example
      expected_length = 3509

      actual_length = described_class.new(input).search_paths.length
      expect(actual_length).to eql expected_length
    end
  end
end
