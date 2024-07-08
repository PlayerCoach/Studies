#include "City.h"


City::City() {}
City::City(const position_t& position, const String& name):position(position),name(name){}

std::ostream& operator<<(std::ostream& ostr, const City& c)
{
	std::cout << c.name << " position: x: " << c.position.x << " y: " << c.position.y;
	return ostr;
}