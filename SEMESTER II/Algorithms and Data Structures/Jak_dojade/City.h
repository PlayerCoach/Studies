#pragma once
#include "String.h"
typedef struct
{
	int y;
	int x;
}position_t;
class City
{
public:
	position_t position;
	String name;
public:
	City();
	City(const position_t& position,const String& name);
	friend std::ostream& operator<<(std::ostream& ostr, const City& city);
};

