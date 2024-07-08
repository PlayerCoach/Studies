#pragma once
#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
#include<stdlib.h>
#include "Swap.h"
template<typename type>
class DoublyLinkedList
{
public:
	struct List
	{
		List* next;
		List* previous;
		type drawer;
	};
private:
	List *head;
	List* tail;
	size_t size;
public:
	//declarations
	DoublyLinkedList();
	DoublyLinkedList(const DoublyLinkedList& orig);
	void PushBack(const type& newnode);
	void PushBack(type&& newnode);
	void PushFront(const type& newnode);
	void PushFront(type&& newnode);
	void PopBack();
	type PopFront();
	void PopOne(std::size_t index);
	List* GetNode(size_t index);
	List* GetHead();
	List* GetTail();
	List* GetPrev(List* Node);
	const size_t GetSize() const;
	type& operator[](std::size_t index);
	const type& operator[](std::size_t index)const;
	DoublyLinkedList<type>& operator=(const DoublyLinkedList<type>& other);//assigment operator with lvalue;
	DoublyLinkedList<type>& operator=(DoublyLinkedList<type>&& other);//assigment operator with rvalue;

	template<typename type2>
	friend std::ostream& operator<<(std::ostream& ostr, const DoublyLinkedList<type2>& DLL);
	void Clear();
	~DoublyLinkedList();

};

//definitions
template<typename type>
DoublyLinkedList<type>::DoublyLinkedList() : head{ nullptr }, tail{nullptr}, size(0) {};

template<typename type>
DoublyLinkedList<type>::DoublyLinkedList(const DoublyLinkedList& orig)
{
	for (size_t i = 0; i < orig.size; i++)
	{
		PushBack(orig[i]);

	}
}

template<typename type>
void DoublyLinkedList<type>::PushBack(const type& newvalue)
{
	List* newnode = new List;
	if (head == nullptr && tail==nullptr)
	{
		head = newnode;
		tail = newnode;
		newnode->drawer = newvalue;
		newnode->next = nullptr;
		newnode->previous = nullptr;
	}
	else if(head==tail)
	{
		head->next = newnode;
		newnode->previous = head;
		newnode->next = nullptr;
		tail = newnode;
		newnode->drawer = newvalue;
	}
	else
	{
	
		newnode->drawer = newvalue;
		newnode->next = nullptr;
		newnode->previous = tail;
		tail->next = newnode;
		tail = newnode;
	}
	size++;
}

template<typename type>
void DoublyLinkedList<type>::PushBack(type&& newvalue)
{
	List* newnode = new List;
	if (head == nullptr && tail == nullptr)
	{
		head = newnode;
		tail = newnode;
		Swap(newnode->drawer, newvalue);
		//newnode->drawer = newvalue;
		//newvalue = nullptr;
		newnode->next = nullptr;
		newnode->previous = nullptr;
	}
	else if (head == tail)
	{
		head->next = newnode;
		newnode->previous = head;
		newnode->next = nullptr;
		tail = newnode;
		Swap(newnode->drawer,newvalue);
	}
	else
	{

		Swap(newnode->drawer, newvalue);
		newnode->next = nullptr;
		newnode->previous = tail;
		tail->next = newnode;
		tail = newnode;
	}
	size++;
}
template<typename type>
void DoublyLinkedList<type>::PushFront(const type& newvalue)
{
	List* newnode = new List;
	if (head == nullptr && tail == nullptr)
	{
		head = newnode;
		tail = newnode;
		newnode->drawer = newvalue;
		newnode->next = nullptr;
		newnode->previous = nullptr;
	}
	else if (head == tail)
	{
		tail->previous = newnode;
		newnode->next = tail;
		newnode->previous = nullptr;
		head = newnode;
		newnode->drawer = newvalue;
	}
	else
	{

		newnode->drawer = newvalue;
		newnode->previous = nullptr;
		newnode->next = head;
		head->previous = newnode;
		head = newnode;
	}
	size++;
}
template<typename type>
void DoublyLinkedList<type>::PushFront(type&& newvalue)

{
	List* newnode = new List;
	if (head == nullptr && tail == nullptr)
	{
		head = newnode;
		tail = newnode;
		Swap(newnode->drawer,newvalue);
		newnode->next = nullptr;
		newnode->previous = nullptr;
	}
	else if (head == tail)
	{
		tail->previous = newnode;
		newnode->next = tail;
		newnode->previous = nullptr;
		head = newnode;
		Swap(newnode->drawer,newvalue);
	}
	else
	{

		Swap(newnode->drawer,newvalue);
		newnode->previous = nullptr;
		newnode->next = head;
		head->previous = newnode;
		head = newnode;
	}
	size++;
}
template<typename type>
void DoublyLinkedList<type>::PopBack()
{
	if (head == nullptr || tail==nullptr)
	{
		throw ;
	}
	else if (head==tail)
	{
		delete tail;
		head = tail = nullptr;
		size=0;
	}
	else
	{
		List* prev = tail->previous;
		prev->next = nullptr;
		delete tail;
		tail = prev;
		size--;

	}
}

template<typename type>
type DoublyLinkedList<type>::PopFront()
{
	type buffer;
	if (head == nullptr && tail == nullptr)
	{
		throw;
	}
	else if (head == tail)
	{
		
		buffer = static_cast<type&&>(head->drawer);
		delete tail;
		head = tail = nullptr;
		size--;
	}
	else
	{
	
		buffer = static_cast<type&&>(head->drawer);
		List* next = head->next;
		next->previous = nullptr;
		delete head;
		head = next;
		size--;

	}
	return buffer;
}
template<typename type>
void DoublyLinkedList<type>::PopOne(std::size_t index)
{
	if (index >= size)throw;
	else if(index == (size - 1)) PopBack();
	else if(index == 0)PopFront();
	else
	{
		List* current = GetNode(index);
		current->previous->next = current->next;
		current->next->previous = current->previous;
		delete current;
		size--;

	}
}
template<typename type>
typename DoublyLinkedList<type>::List* DoublyLinkedList<type>::GetPrev(List* Node)
{
	if (head==Node)throw;
	else return  Node->previous;
}
template<typename type>
typename DoublyLinkedList<type>::List* DoublyLinkedList<type>::GetNode(size_t index)
{
	if (index>=size)throw;
	else
	{
		List* SelectedNode = head;
		while (index > 0)
		{
			SelectedNode = SelectedNode->next;
			index--;
		}
		return SelectedNode;
	}
}
template<typename type>
typename DoublyLinkedList<type>::List* DoublyLinkedList<type>::GetHead()
{
	
		return head;
	
}
template<typename type>
typename DoublyLinkedList<type>::List* DoublyLinkedList<type>::GetTail()
{

	return tail;

}

template<typename type>
type& DoublyLinkedList<type>::operator[](std::size_t index)
{
	if (index >= size)
	{
		throw;
	}

	List* SelectedNode = head;
	while (index > 0)
	{
		SelectedNode = SelectedNode->next;
		index--;
	}
	return SelectedNode->drawer;
}
template<typename type>
const size_t DoublyLinkedList<type>::GetSize() const
{
	return this->size;
}
template<typename type>
const type& DoublyLinkedList<type>::operator[](std::size_t index) const
{
	if (index >= size)
	{
		throw;
	}

	const List* SelectedNode = head;
	while (index > 0)
	{
		SelectedNode = SelectedNode->next;
		index--;
	}
	return SelectedNode->drawer;
}

template<typename type>
DoublyLinkedList<type>& DoublyLinkedList<type>::operator=(const DoublyLinkedList<type>& other)
{

	this->Clear();
	for (int i = 0; i < other.GetSize(); i++)
	{
		this->PushBack(other[i]);
	}
	return *this;
}

template<typename type>
DoublyLinkedList<type>& DoublyLinkedList<type>::operator=(DoublyLinkedList<type>&& other)
{
	Clear();
	head = other.head;
	tail = other.tail;
	size = other.size;
	other.head = nullptr;
	other.tail = nullptr;
	other.size = 0;
	return *this;
}
template<typename type>
std::ostream& operator<<(std::ostream& ostr, const DoublyLinkedList<type>& DLL)
{
	for (int i = 0; i < DLL.GetSize(); i++)
	{
		ostr << DLL[i] << std::endl;
	}
	return ostr;
}

template<typename type>
void DoublyLinkedList<type>::Clear()
{
	while(this->size!=0)
	{
		PopBack();
	}
}


template<typename type>
DoublyLinkedList<type>::~DoublyLinkedList()
{
	this->Clear();
}




