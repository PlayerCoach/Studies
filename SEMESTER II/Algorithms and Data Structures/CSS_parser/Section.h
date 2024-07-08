#pragma once
#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
#include "String.h"
#include "DoublyLinkedList.h"
#include "SingleLinkedList.h"
#include "Attribute.h"
#include "Swap.h"
class Section
{
public:
	DoublyLinkedList<Attribute> Attributes;
	SingleLinkedList<String> Selectors;

	Section();
	Section(const Section& other);
	Section(Section&& other);
	Section& operator=(const Section& other);//assigment operator with lvalue;
	Section& operator=(Section&& other);//assigment operator with rvalue;
	friend std::ostream& operator<<(std::ostream& ostr,  Section& s);
};


