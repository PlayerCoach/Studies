#pragma once
#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
#include "String.h"
class Attribute
{
public:
	String name;
	String value;
	friend std::ostream& operator<<(std::ostream& ostr, const Attribute& a);
};

