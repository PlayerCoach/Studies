#pragma once
#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
#include<string.h>
#include<math.h>
#include "Swap.h"
class String
{
	char* string;
public:
	String();
	String(const char* word);
	String(const String& source);//copy constructor 
	String(String&& toMove) noexcept;//move constructor
	String& operator=(const String& other) noexcept;//assigment operator with lvalue;
	String& operator=(String&& other) noexcept;//assigment operator with rvalue;
	int Length() const;
	bool operator==(const String& other) const ;
	String operator+(const String& other)const;
	String operator+(const char& other)const;
	const char operator[](int index)const;
	char operator[](int index);
	int ToInt()const;
	bool IsInt()const;
	String GetString()const;
	void Reverse();
	friend std::ostream& operator<<(std::ostream& ostr, const String& s);
	void ToValidString();
	String CutString();
	~String();
};

