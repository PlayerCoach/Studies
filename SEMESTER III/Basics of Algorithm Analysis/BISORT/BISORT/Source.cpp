#include <stdlib.h>
#include <vector>
#include <string>
#include <cstdlib>
#include <cstring>
#include <iostream>
#include <deque>
#include <unordered_map>
#include <algorithm>

void create_hash_map(std::unordered_map<int,int>& book_positions, std::deque<int>& books)
{
	for (int i = 0; i < books.size(); ++i) {
		book_positions[books[i]] = i;
	}
}
void change_position(std::unordered_map<int, int>& book_positions, std::deque<int>& books, int k,std::vector<int>& real_books_positions, int& index_to_change)
{
	int temp_book = books[k - 1]; // nazwa
	books.erase(books.begin() + k - 1);
	int position = book_positions[temp_book]; // indeks w prawdziwych

	int name = real_books_positions[index_to_change]; // nazwa tej ksi¹¿ki co zmieniam

	book_positions[temp_book] = index_to_change;
	book_positions[name] = position;


	std::swap(real_books_positions[position], real_books_positions[index_to_change]);
	index_to_change--;


}
void print_state(const std::vector<int>& real_books_positions) 
{
	
	for (const auto& position : real_books_positions)
	{
		std::cout << position << " ";
	}
	std::cout << std::endl;
}
int main()
{
	int number_of_books= 0;
	std::deque<int> books;
	std::vector<int> steps;
	std::vector<int> checkpoints;
	int buffer;
	std::unordered_map<int, int> book_positions;

	std::cin >> number_of_books;

	for (int i = 0; i < number_of_books; i++)
	{
		std::cin >> buffer;
		books.push_back(buffer);
	}

	for (int i = 0; i < number_of_books; i++)
	{
		std::cin >> buffer;
		steps.push_back(buffer);
	}

	
	while (std::cin >> buffer )
	{
		checkpoints.push_back(buffer);
	}

	create_hash_map(book_positions, books);
	std::vector<int> real_books_positions(books.begin(), books.end());

	std::sort(books.begin(), books.end(), std::greater<int>());

	int current_state = 0;
	int index_to_change = books.size() - 1;
	for (int i = 0; i < number_of_books; i++)
	{
		change_position(book_positions, books, steps[i], real_books_positions, index_to_change);

		if ((i+1) == checkpoints[current_state])
		{
				print_state(real_books_positions);
				current_state++;
		}
			
	}

	return 0;
}