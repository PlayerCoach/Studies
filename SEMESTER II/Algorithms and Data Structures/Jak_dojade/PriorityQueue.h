#pragma once
#pragma once
#include <iostream>
#include <math.h>
#include <stdlib.h>
#include "Vector.h"

template<typename type>
class PriorityQueue
{
private:

	Vector<type> heap;

	const size_t Get_parent(size_t index)const;
	const size_t Get_lChild(size_t index)const;//gets left child of node
	const size_t Get_rChild(size_t index)const;//gets right child of node
	void Heapify_up(size_t index);
	void Heapify_down(size_t index);

public:
	PriorityQueue();
	void Push(const type& value);
	void Push(type&& value);
	type Pop();
	size_t Size();



};

template<typename type>
PriorityQueue<type>::PriorityQueue() :heap(Vector<type>()) {}
template<typename type>
const size_t PriorityQueue<type>::Get_parent(size_t index)const
{
	if (index == 0)
		return 0;
	else
		return ((index - 1) / 2);
}

template<typename type>
const size_t PriorityQueue<type>::Get_lChild(size_t index)const
{
	return (index * 2) + 1;
}

template<typename type>
const size_t PriorityQueue<type>::Get_rChild(size_t index)const
{
	return (index * 2) + 2;
}

template<typename type>
void PriorityQueue<type>::Heapify_up(size_t index)
{
	if (index == 0)
		return;

	if (index!=0 && heap[index] < heap[Get_parent(index)] )
		return;
	else
	{
		Swap(heap[index], heap[Get_parent(index)]);
			Heapify_up(Get_parent(index));
	}
}

template<typename type>
void PriorityQueue<type>::Heapify_down(size_t index)
{
	if (heap.Size() < 1)
		throw;
	 else if (heap.Size() == 1)
		return;
	 else if (heap.Size() == 2)
	{
		if (heap[0] < heap[1])
			Swap(heap[0], heap[1]);
	}
	else
	{
		size_t l_child = Get_lChild(index);
		size_t r_child = Get_rChild(index);
		if (l_child >= heap.Size() && r_child >= heap.Size())
			return;
			if (l_child < heap.Size() && r_child < heap.Size())
			{
				size_t max_child = heap[l_child] >= heap[r_child] ? l_child : r_child;//gets the index of the greater child

				if (heap[index] >= heap[max_child])
					return;
			   else
			   {
				   Swap(heap[index], heap[max_child]);
				   Heapify_down(max_child);
			   }

			}
			else if (l_child < heap.Size() && r_child >= heap.Size())
			{
					if (heap[index] >= heap[l_child])
						return;
					else
					{
						Swap(heap[index], heap[l_child]);
						Heapify_down(l_child);
					}
			}
	}

}


template<typename type>
void PriorityQueue<type>::Push(const type& value)
{
	heap.PushBack(value);
	Heapify_up(heap.Size() - 1);
}

template<typename type>
void PriorityQueue<type>::Push(type&& value)
{
	heap.PushBack(static_cast<type&&>(value));
	Heapify_up(heap.Size() - 1);
}

template<typename type>
type PriorityQueue<type>::Pop()
{
	if (heap.Size() < 1)
		throw;

	type buffer;
	Swap(heap[0], heap[heap.Size() - 1]);
	buffer = static_cast<type&&>(heap[heap.Size() - 1]);
	heap.PopBack();
	if(heap.Size()>0)
	Heapify_down(0);

	return buffer;
	
}

template<typename type>
size_t PriorityQueue<type>::Size()
{
	return heap.Size();
}