#include <iostream>
#include <stdlib.h>
#include <vector>
#include <string>
#include <cstdlib>
#include <cstring>
#include <iostream>
//Inspirations for LCS algorithm: https://www.geeksforgeeks.org/printing-longest-common-subsequence/



void LCS(std::string A, std::string B, std::vector<std::vector<int>>& indexes)
{
	
	for (int i = 0; i <= A.size(); i++)
	{
		for(int j = 0; j <= B.size(); j++)
		{
			if (i == 0 || j == 0)
				indexes[i][j] = 0;
			else if (A[i - 1] == B[j - 1])
				indexes[i][j] = indexes[i - 1][j - 1] + 1;
			else
				indexes[i][j] = std::max(indexes[i - 1][j], indexes[i][j - 1]);
		}
	}
}

std::string get_LCS(std::string A, std::string B, std::vector<std::vector<int>>& indexes, std::vector<std::vector<int>>& positions)
{
	int index = indexes[A.size()][B.size()];

	char* lcs = new char[index + 1];
	lcs[index] = '\0';

	int i = A.size(), j = B.size();
	while (i > 0 && j > 0) {
	
		if (A[i - 1] == B[j - 1])
		{
			positions[index-1][0] = i;
			positions[index-1][1] = j;
			lcs[index - 1] = A[i - 1];
			i--;
			j--;
			index--;
		}
		else if (indexes[i - 1][j] > indexes[i][j - 1])
			i--;
		else
			j--;
	}

	std::string result(lcs);
	delete[] lcs;
	return result;

}
void print_result(std::string result, std::vector<std::vector<int>>& indexes, int case_index, int length, std::vector<std::vector<int>>& positions)
{
	if (length <= 0)
		std::cout << "case " << case_index << " N" << std::endl;
	else
	{
		std::cout << "case " << case_index << " Y" << std::endl;
		std::cout << length << std::endl;
		for (int i = 0; i < result.size(); i++)
		{
			std::cout  << result[i] <<" " << positions[i][1]<<" "<< positions[i][0]<< std::endl;

		}
	}

}
void initialize_LCS(std::string A, std::string B, int& case_index)
{
	std::vector<std::vector<int>> indexes(A.size() + 1, std::vector<int>(B.size() + 1));
	std::vector<std::vector<int>> positions(std::max(A.size() + 1, B.size()+1), std::vector<int>(2));
	int places[1000][2];
	int length = 0;
	LCS(A, B, indexes);
	std::string result = get_LCS(A, B, indexes, positions);
	length = result.size();
	print_result(result, indexes, case_index, length, positions);
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
		initialize_LCS(strings_tab[i][1], strings_tab[i][0],case_index);
	}

	return 0;
}

