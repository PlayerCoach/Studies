#include "djikstra_t.h"

bool djikstra_t::operator<(const djikstra_t& other) const
{
	return distance > other.distance;//on purpose
}
bool djikstra_t::operator>(const djikstra_t& other) const
{
	return distance < other.distance;//on purpose,so i dont have to change priority queue
}
bool djikstra_t::operator<=(const djikstra_t& other) const
{
	return distance >= other.distance;//on purpose
}
bool djikstra_t::operator>=(const djikstra_t& other) const
{
	return distance <= other.distance;//on purpose,so i dont have to change priority queue
}