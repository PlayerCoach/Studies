#include <iostream>
#include <stdlib.h>
#include <vector>
#include <string>
#include <cstdlib>
#include <cstring>
#include <iostream>
#include <queue>
#include <stack>
#include <algorithm>


//Inspirations : https://www.programiz.com/dsa/graph-bfs // https://www.geeksforgeeks.org/iterative-deepening-searchids-iterative-deepening-depth-first-searchiddfs/ 
// https://tutorialhorizon.com/algorithms/depth-first-search-dfs-in-2d-matrix2d-array-iterative-solution/

void BFS(int starting_vertex, std::vector<std::vector<int>>& graph)
{
	std::vector<bool> visited(graph.size(), false);
	visited[starting_vertex - 1] = true;
	std::queue<int> queue;

	queue.push(starting_vertex - 1);

	while (!queue.empty()) {
		int current_vertex = queue.front();
		queue.pop();

		std::cout << current_vertex + 1 << " ";

		std::sort(graph[current_vertex].begin(), graph[current_vertex].end());

		for (int u : graph[current_vertex]) {
			if (u != 100000 && !visited[u-1]) {
				queue.push(u-1);
				visited[u-1] = true;
			}
		}
	}
	std::cout << std::endl;

}

void DFS(int starting_vertex, std::vector<std::vector<int>>& graph) {
	std::vector<bool> visited(graph.size(), false);
	std::stack<int> stack;

	stack.push(starting_vertex - 1);

	while (!stack.empty()) {
		int current_vertex = stack.top();
		stack.pop();

		if (!visited[current_vertex]) {
			visited[current_vertex] = true;
			std::cout << current_vertex + 1 << " ";

			std::sort(graph[current_vertex].begin(), graph[current_vertex].end(), std::greater<int>());
			for (int u : graph[current_vertex]) {
				if (u != 100000 && !visited[u - 1]) {
					stack.push(u - 1);
				}
			}
		}
	}
	std::cout << std::endl;
}

void handle_input(int vertex, int param_b, std::vector<std::vector<int>>& graph)
{
	if (param_b == 1)
		BFS(vertex, graph);
	else if (param_b == 0)
		DFS(vertex, graph);
}


int main()
{
	int number_of_graphs = 0; 
	int vertex_index = 0;
	int vertex_deg = 0;
	int graph_size = 0;
	int a_param = -1;
	int b_param = -1;
	

	std::cin >> number_of_graphs;

	for (int i = 0; i < number_of_graphs; i++)
	{
		std::cin >> graph_size;
		std::vector<std::vector<int>> adjacency_vector(graph_size, std::vector<int>(graph_size, 100000));
		for (int j = 0; j < graph_size; j++)
		{
			std::cin >> vertex_index;
			std::cin >> vertex_deg;
			for (int k = 0; k < vertex_deg; k++)
			{
				std::cin >> adjacency_vector[j][k];
			}
		}

		

		std::cout << "graph " << i + 1 << std::endl;
		a_param = -1;
		b_param = -1;
		while (a_param != 0 || b_param != 0)
		{
			std::cin >> a_param;
			std::cin >> b_param;

			if (a_param != 0 || b_param != 0)
				handle_input(a_param, b_param, adjacency_vector);
			
		}
	}


	return 0;
}

