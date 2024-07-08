#include "Section.h"


Section::Section() :Attributes(), Selectors() {}
Section::Section(const Section& other)
{

	this->Selectors = other.Selectors;
	this->Attributes = other.Attributes;
}
Section::Section(Section&& other)
{
	this->Selectors = static_cast<SingleLinkedList<String>&&>(other.Selectors);
	this->Attributes = static_cast<DoublyLinkedList<Attribute>&&>(other.Attributes);
}
Section& Section::operator=(const Section& other)
{

	this->Attributes.Clear();
	this->Selectors.Clear();
	for (int i = 0; i < other.Selectors.GetSize(); i++)
	{
		this->Selectors.PushBack(other.Selectors[i]);
	}
	for (int i = 0; i < other.Attributes.GetSize(); i++)
	{
		this->Attributes.PushBack(other.Attributes[i]);
	}
	return *this;
}

Section& Section::operator=(Section&& other)
{
	
	this->Selectors = static_cast<SingleLinkedList<String>&&>(other.Selectors);
	this->Attributes=static_cast<DoublyLinkedList<Attribute>&&>(other.Attributes);
	return *this;
}

std::ostream& operator<<(std::ostream& ostr,  Section& s)
{
	for (int i = 0; i < s.Selectors.GetSize(); i++)
	{
		ostr << s.Selectors[i];
			if(i!=(s.Selectors.GetSize()-1))
				ostr << ", ";
	}
	if (s.Attributes.GetHead() != nullptr)
	{
		ostr << std::endl << "{" << std::endl;
		for (int j = 0; j < s.Attributes.GetSize(); j++)
		{
			ostr << s.Attributes[j] << std::endl;
		}
		ostr << "}";
	}
	return ostr;
}