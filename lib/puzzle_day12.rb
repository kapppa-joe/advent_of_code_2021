module Day12
  class PassagePathing
    def initialize(input_array)
      @graph = make_graph(input_array)
    end

    def make_graph(input_array)
      graph = Hash.new { |hash, key| hash[key] = [] }
      input_array.reduce(graph) do |graph, line|
        node_a, node_b = line.split('-')
        graph[node_a] << node_b
        graph[node_b] << node_a
        graph
      end
    end

    def possible_next_nodes(next_nodes, visited)
      small_caves_visited = visited.filter { |node| node == node.downcase }
      next_nodes - small_caves_visited
    end

    def search_paths(graph: @graph, curr: 'start', dest: 'end', visited: [])
      return [[*visited, curr].join(',')] if curr == dest

      next_nodes = possible_next_nodes(graph[curr], visited)
      return [] if next_nodes.empty?

      path = visited.clone
      path << curr
      recur_results = next_nodes.map do |next_node|
        search_paths(
          graph: graph,
          curr: next_node,
          dest: dest,
          visited: path
        )
      end
      recur_results.flatten
    end
  end
end


if __FILE__ == $PROGRAM_NAME
  require_relative './utils'
  input_array = read_input_file(12, 'string')
  passage = Day12::PassagePathing.new(input_array)

  part_a_solution = passage.search_paths.length
  puts "solution for part A: #{part_a_solution}"

  # part_b_solution = scorer.incomplete_strings_middle_score(input_array)
  # puts "solution for part B: #{part_b_solution}"
end
