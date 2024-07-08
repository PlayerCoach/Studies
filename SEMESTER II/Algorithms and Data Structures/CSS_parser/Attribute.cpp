#include "Attribute.h"

std::ostream& operator<<(std::ostream& ostr, const Attribute& a)
{
	ostr << a.name << ": " << a.value;
	return ostr;
}

