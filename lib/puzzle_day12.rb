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
      path = visited.clone
      path << curr

      if graph[curr].include?(dest)
        path << dest
        return [path.join(',')]
      else
        next_nodes = possible_next_nodes(graph[curr], visited)
        return [] if next_nodes.empty?

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
end
