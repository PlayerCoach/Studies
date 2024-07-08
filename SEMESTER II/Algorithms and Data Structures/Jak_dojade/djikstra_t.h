#pragma once
#include "Vector.h"
class djikstra_t
{
public:
	
	int index;
	int previous_index;
	long long distance;

	bool operator<(const djikstra_t& other) const;
	bool operator>(const djikstra_t& other) const;
	bool operator<=(const djikstra_t& other) const;
	bool operator>=(const djikstra_t& other) const;
};

