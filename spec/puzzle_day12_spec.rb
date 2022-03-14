require 'puzzle_day12'

describe Day12::PassagePathing do
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

    xcontext 'basic example' do
      let(:passage) { described_class.new(day12_basic_example) }

      it 'solve the basic example correctly' do
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

        expect(passage.search_paths).to eql expected_output
      end
    end
  end
end
