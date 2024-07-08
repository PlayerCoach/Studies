#pragma once
#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
#include<iostream>
#include<stdlib.h>
#include "Swap.h"
template<typename type>
class SingleLinkedList
{
private:
	struct List
	{
		List* next;
		type drawer;
	};
	List* head;
	size_t size;
public:
	//declarations
	SingleLinkedList();
	SingleLinkedList(const SingleLinkedList& orig);
	void PushBack(const type& newnode);
	void PushBack(type&& newnode);
	void PushFront(const type& newnode);
	void PushFront(type&& newnode);
	void PopBack();
	List* GetHead();
	List* GetNext(List* Node);
	const size_t GetSize() const;
	type& operator[](std::size_t index);
	const type& operator[](std::size_t index)const;
	SingleLinkedList<type>& operator=(const  SingleLinkedList<type>& other);//assigment operator with lvalue;
	SingleLinkedList<type>& operator=(SingleLinkedList<type>&& other);//assigment operator with rvalue;

	template<typename type2>
	friend std::ostream& operator<<(std::ostream& ostr);
	void Clear();
	~SingleLinkedList();

};

//definitions
template<typename type>
SingleLinkedList<type>::SingleLinkedList() : head{ nullptr }, size(0) {};

template<typename type>
SingleLinkedList<type>::SingleLinkedList(const SingleLinkedList& orig)
{
	for(size_t i=0;i<orig.size;i++)
	{
		PushBack(orig[i]);
		
	}
}

template<typename type>
void SingleLinkedList<type>::PushBack(const type& newvalue) 
{
	List* newnode = new List;
	if (head == nullptr)
	{
		head = newnode;
		newnode->drawer = newvalue;
		newnode->next = nullptr;
	}
	else
	{
		List* Lastnode = head;
		while (Lastnode->next != nullptr)
		{
			Lastnode = Lastnode->next;
		}
		Lastnode->next = newnode;
		newnode->drawer = newvalue;
		newnode->next = nullptr;
	}
	size++;
}

template<typename type>
void SingleLinkedList<type>::PushBack(type&& newvalue)
{
	List* newnode = new List;
	if (head == nullptr)
	{
		head = newnode;
		Swap(newnode->drawer,newvalue);
		newnode->next = nullptr;
	}
	else
	{
		List* Lastnode = head;
		while (Lastnode->next != nullptr)
		{
			Lastnode = Lastnode->next;
		}
		Lastnode->next = newnode;
		Swap(newnode->drawer,newvalue);
		newnode->next = nullptr;
	}
	size++;
}
template<typename type>
void SingleLinkedList<type>::PushFront(const type& newvalue)
{
	List* newnode = new List;
	if (head == nullptr)
	{
		head = newnode;
		newnode->drawer = newvalue;
		newnode->next = nullptr;
	}
	else
	{
		List* buffer = head;
		head = newnode;
		newnode->drawer = newvalue;
		newnode->next = buffer;
		
	}
	size++;
}
template<typename type>
void SingleLinkedList<type>::PushFront(type&& newvalue)
{
	List* newnode = new List;
	if (head == nullptr)
	{
		head = newnode;
		Swap(newnode->drawer, newvalue);
		newnode->next = nullptr;
	}
	else
	{
		List* buffer = head;
		head = newnode;
		Swap(newnode->drawer,newvalue);
		newnode->next = buffer;
		
		
	}
	size++;
}
template<typename type>
void SingleLinkedList<type>::PopBack()
{
	if (head == nullptr)
	{
		throw;
	}
	else if (size == 1)
	{
		delete head;
		head = nullptr;
		size--;
	}
	else
	{
		List* SecondLastnode = head;
		while (SecondLastnode->next->next != nullptr)
		{
			SecondLastnode = SecondLastnode->next;

		}
		delete SecondLastnode->next;
		SecondLastnode->next = nullptr;
		size--;

	}
}
template<typename type>
typename SingleLinkedList<type>::List* SingleLinkedList<type>::GetHead()
{

	return head;

}
template<typename type>
typename SingleLinkedList<type>::List* SingleLinkedList<type>::GetNext(List* Node)
{
	if (Node->next==nullptr)throw;
	else return  Node->next;
}

template<typename type>
const size_t SingleLinkedList<type>::GetSize() const
{
	return this->size;
}
template<typename type>
type& SingleLinkedList<type>::operator[](std::size_t index)
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
const type& SingleLinkedList<type>::operator[](std::size_t index) const
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
SingleLinkedList<type>& SingleLinkedList<type>::operator=(const SingleLinkedList<type>& other)
{
	this->Clear();
	for (int i = 0; i < other.GetSize(); i++)
	{
		this->PushBack(other[i]);
	}
	return *this;
}
template<typename type>
SingleLinkedList<type>& SingleLinkedList<type>::operator=(SingleLinkedList<type>&& other)
{
	Clear();
	head = other.head;
	size = other.size;
	other.head = nullptr;
	other.size = 0;
	return *this;
}

template<typename type>
std::ostream& operator<<(std::ostream& ostr, const SingleLinkedList<type>& SLL)
{
	for (int i = 0; i < SLL.GetSize(); i++)
	{
		ostr << SLL[i] << std::endl;
	}
	return ostr;
}

template<typename type>
void SingleLinkedList<type>::Clear()
{
	while (this->size != 0)
	{
		PopBack();
	}
}

 template<typename type>
 SingleLinkedList<type>::~SingleLinkedList()
 {
	 Clear();
 }




