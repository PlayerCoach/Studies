#pragma once
#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
#include "Section.h"
#include "Swap.h"
#define T 8
class BlockList
{
public:
	struct List
	{
		Section section[T];
		List* next;
		List* previous;
		size_t section_index=0;//points to furthest empty bracket on the left

	};
private:
	size_t size;
	int counter;
	List* head;
	List* tail;

public:
	//declarations
	BlockList();
	void PushBack(const Section& newnode);
	void PushBack(Section&& newnode);
	void PopBack();
	void PopOne(std::size_t index);
	List* GetNode(size_t index);
	List* GetNext(List* Node);
	List* GetHead();
	List* GetPrev(List* Node);
	List* GetTail();
	const size_t GetSize() const;
	const int GetCounter() const;
	Section& operator[](std::size_t index);
	const Section& operator[](std::size_t index)const;
	bool IsSectionEmpty(size_t index);
	friend std::ostream& operator<<(std::ostream& ostr,  BlockList& BL);
	~BlockList();

};



