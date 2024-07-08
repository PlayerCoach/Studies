#pragma once
#include <iostream>
#include <stdlib.h>
#include "Swap.h"
template<typename type>
class Vector
{
private:
	type* m_Data = nullptr;
	size_t m_Size = 0;
	size_t m_Capacity = 0;
	void Realloc(size_t newCapacity);

public:
	Vector();
	Vector(size_t capacity);
	Vector(const Vector& orig);
	void PushBack(const type& value);
	void PushBack(type&& value);
	void PopBack();
	const type& operator[](size_t index) const;
	type& operator[](size_t index);
	Vector<type>& operator=(const Vector<type>& other);
	Vector<type>& operator=(Vector<type>&& other);
	const size_t Size() const;
	void Clear();
	~Vector();


};

template<typename type>
void Vector<type>::Realloc(size_t newCapacity)
{
	if (newCapacity > m_Capacity)
	{
		type* new_data = new type[newCapacity];
		for (int i = 0; i < m_Size; i++)
			new_data[i] = static_cast<type&&>(m_Data[i]);
		delete[] m_Data;
		m_Data = new_data;
		m_Capacity = newCapacity;
	}
	
	
}

template<typename type>
Vector<type>::Vector()
{
	Realloc(10);
}

template<typename type>
Vector<type>::Vector(size_t capacity)
{
	Realloc(capacity);
}

template<typename type>
Vector<type>::Vector(const Vector& orig)
{
	Realloc(orig.m_Capacity);
	m_Size = orig.m_Size;
	for (int i = 0; i < orig.m_Size;i++)
		m_Data[i] = orig.m_Data[i];
}

template<typename type>
void Vector<type>::PushBack(const type& value)
{
	if (m_Size >= m_Capacity)
	{
		Realloc(2 * m_Capacity);
	}

		m_Data[m_Size] = value;
	m_Size++;

}

template<typename type>
void Vector<type>::PushBack(type&& value)
{
	if (m_Size >= m_Capacity)
	{
		Realloc(2 * m_Capacity);
	}

		m_Data[m_Size]=static_cast<type&&>(value);
	m_Size++;
}

template<typename type>
void Vector<type>::PopBack()
{
	if (m_Size > 0)
	{
		m_Size--;
		m_Data[m_Size].~type();
	}
}

template<typename type>
const type& Vector<type>::operator[](size_t index) const
{
	if (index >= m_Size)throw;
	else
		return m_Data[index];
}

template<typename type>
type& Vector<type>::operator[](size_t index)
{
	if (index >= m_Size)throw;
	else
		return m_Data[index];
}
template<typename type>
Vector<type>& Vector<type>::operator=(const Vector<type>& other) 
{
	this->Clear();
	m_Capacity = 0;
	Realloc(other.m_Capacity);
	for (int i = 0; i < other.m_Size; i++)
	{
		this->PushBack(other[i]);
	}
	this->m_Size = other.m_Size;
	return *this;
}

template<typename type>

Vector<type>& Vector<type>::operator=(Vector<type>&& other)
{
	m_Capacity = 0;
	Realloc(other.m_Capacity);
	m_Data = other.m_Data;
	m_Size = other.m_Size;
	other.m_Data = nullptr;
	return *this;
}

template<typename type>
const size_t Vector<type>::Size() const
{
	return m_Size;
}
template<typename type>
void Vector<type>::Clear()
{
	while(m_Size>0)
		PopBack();

}

template<typename type>
Vector<type>::~Vector()
{
	delete[] m_Data;
}

