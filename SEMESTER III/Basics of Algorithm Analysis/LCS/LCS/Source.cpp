#include <iostream>
#include <stdlib.h>
#include <vector>
#include <string>

//Inspirations for LCS algorithm: https://www.geeksforgeeks.org/longest-common-subsequence-dp-4/
 

int LCS(std::string A, std::string B, int i, int j, std::vector<char>& common_sub, std::vector<int>& indexes)
{
	if (A[i] == '\0' || B[j] == '\0')
		return 0;
	else if (A[i] == B[j])
	{
		indexes.push_back(i);
		indexes.push_back(j);
		common_sub.push_back(A[i]);
		return (1 + LCS(A, B, i + 1, j + 1, common_sub, indexes));
	}
		
	else
	{
		
		return std::max(LCS(A, B, i + 1, j, common_sub, indexes), LCS(A, B, i, j + 1, common_sub, indexes));
	}
}

void print_result(std::vector<char>& common_sub, std::vector<int>& indexes, int case_index, int length)
{
	if(length <= 0)
		std::cout << "case " << case_index << " N" << std::endl;
	else
	{
		std::cout << "case " << case_index << " Y" << std::endl;
		std::cout << length << std::endl;
		for (int i = 0; i < common_sub.capacity(); i+=2)
		{
			//std::cout << common_sub[i / 2] << " " << indexes[i] << " " << indexes[i + 1] << std::endl;

		}
	}
	
}
void initialize_LCS(std::string A, std::string B, int i, int j, int max_common_length, int* case_index)
{
	std::vector<char> common_sub;
	std::vector<int>indexes;
	int length = LCS(A, B, i, j, common_sub, indexes);
	print_result(common_sub, indexes, *case_index, length);
	case_index++;

}
int main()
{
	int number_of_series = 0; // N, max 1000
	int case_index = 1;

	std::cin >> number_of_series;

	std::vector<std::vector<std::string>> strings_tab(number_of_series, std::vector<std::string>(2));
	std::vector<std::vector<int>> string_length_tab(number_of_series, std::vector<int>(2));

	for (int i = 0; i < number_of_series; i++)
	{
		std::cin >> string_length_tab[i][0];
		std::cin >> strings_tab[i][0];
		std::cin >> string_length_tab[i][1];
		std::cin >> strings_tab[i][1];

	}

	for (int i = 0; i < number_of_series; i++)
	{
		initialize_LCS(strings_tab[i][0], strings_tab[i][1], 0, 0, std::min(string_length_tab[i][0], string_length_tab[i][1]), &case_index);
	}

	return 0;
}

