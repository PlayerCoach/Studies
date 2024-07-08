#include "BlockList.h"

BlockList::BlockList() : head{ nullptr }, tail{ nullptr }, size(0),counter(0) {};

void BlockList::PushBack(const Section& newsection)
{
	if (head == nullptr || tail == nullptr)
	{
		List* newnode = new List;
		head = newnode;
		tail = newnode;
		newnode->section[0] = newsection;
		newnode->next = nullptr;
		newnode->previous = nullptr;
		tail->section_index++;
		counter++;
		size++;
	}
	else if (head==tail && tail->section_index == T )
	{
		List* newnode = new List;
		head->next = newnode;
		newnode->previous = head;
		newnode->next = nullptr;
		tail = newnode;
		newnode->section[0] = newsection;
		tail->section_index++;
		counter++;
		size++;
	}
	else if (size >= 2 && tail->section_index == T )
	{
		List* newnode = new List;
		newnode->section[0] = newsection;
		newnode->next = nullptr;
		newnode->previous = tail;
		tail->next = newnode;
		tail = newnode;
		tail->section_index++;
		counter++;
		size++;
	}
	else if (tail->section_index > 0 && tail->section_index < (T))
	{
		tail->section[tail->section_index] = newsection;
		tail->section_index++;
		counter++;
	}
}
void BlockList::PushBack(Section&& newsection)
{
	if (head == nullptr || tail == nullptr)
	{
		List* newnode = new List;
		head = newnode;
		tail = newnode;
		//Swap(newnode->section[0],newsection);
		newnode->section[0] = static_cast<Section&&>(newsection);
		newsection.Attributes.Clear();
		newsection.Selectors.Clear();
		newnode->next = nullptr;
		newnode->previous = nullptr;
		tail->section_index++;
		counter++;
		size++;
	}
	else if (head == tail && tail->section_index == T )
	{
		List* newnode = new List;
		head->next = newnode;
		newnode->previous = head;
		newnode->next = nullptr;
		tail = newnode;
		//Swap(newnode->section[0], newsection);
		newnode->section[0] = static_cast<Section&&>(newsection);
		newsection.Attributes.Clear();
		newsection.Selectors.Clear();
		tail->section_index++;
		counter++;
		size++;
	}
	else if (size >= 2 && tail->section_index == T )
	{
		List* newnode = new List;
		//Swap(newnode->section[0], newsection);
		newnode->section[0] = static_cast<Section&&>(newsection);
		newsection.Attributes.Clear();
		newsection.Selectors.Clear();
		newnode->next = nullptr;
		newnode->previous = tail;
		tail->next = newnode;
		tail = newnode;
		tail->section_index++;
		counter++;
		size++;
	}
	else if (tail->section_index > 0 && tail->section_index < (T))
	{
		//Swap(tail->section[tail->section_index], newsection);
		tail->section[tail->section_index] = static_cast<Section&&>(newsection);
		newsection.Attributes.Clear();
		newsection.Selectors.Clear();
		tail->section_index++;
		counter++;
	}
}
void BlockList::PopBack()
{
	if (head == nullptr || tail == nullptr)
	{
		throw;
	}
	else
	{
			tail->section[tail->section_index-1].Attributes.~DoublyLinkedList();
			tail->section[tail->section_index-1].Selectors.~SingleLinkedList();
			do
			{
				tail->section_index--;
			} while (tail->section_index > 0 && tail->section[tail->section_index - 1].Attributes.GetHead() == nullptr);//if head is nullptr then list of attributes is empty so the section is empty too
			counter--;
	}

	if (tail->section_index == 0)
	{
		if (head == tail)
		{
			delete tail;
			head = tail = nullptr;
			size = 0;
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
}

void BlockList::PopOne(std::size_t index)
{
	List* currentNode = head;
	if (head == nullptr)throw;
	else
	{
		int i = -1, currentIndex = 0;
		do
		{
			if (currentNode->section[currentIndex].Attributes.GetHead() != nullptr)i++;
			if (i == index)break;
			currentIndex++;
			if (currentIndex == (currentNode->section_index))
			{
				if (currentNode->next == nullptr)throw;
				currentNode = currentNode->next;
				currentIndex = 0;

			}

		} while (i != index);
		currentNode->section[currentIndex].Attributes.~DoublyLinkedList();
		currentNode->section[currentIndex].Selectors.~SingleLinkedList();
		counter--;
		if (currentNode->section_index == (currentIndex + 1))
		{
			do
			{
				currentNode->section_index--;
			} while (currentNode->section_index > 0 && currentNode->section[tail->section_index - 1].Attributes.GetHead() == nullptr);
			
		}
		if (currentNode->section_index == 0)
		{
			if (head == tail)
			{
				delete tail;
				head = tail = nullptr;
				size = 0;
			}
			else if (head == currentNode)
			{
				List* next = head->next;
				next->previous = nullptr;
				delete head;
				head = next;
				size--;
			}
			else if (tail == currentNode)
			{
				List* prev = tail->previous;
				prev->next = nullptr;
				delete tail;
				tail = prev;
				size--;
			}
			else
			{
				List* prev = currentNode->previous;
				prev->next = currentNode->next;
				delete currentNode;
				size--;
			}
		}
	}

}
BlockList::List* BlockList::GetNode(size_t index)
{
	if (index >= size)throw;
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
BlockList::List* BlockList::GetNext(List* Node)
{
	if (Node->next == nullptr)throw;
	else return Node->next;
}
BlockList::List* BlockList::GetHead()
{
	if (head == nullptr)throw;
	else return head;
}
BlockList::List* BlockList::GetPrev(List* Node)
{
	if (Node->previous==nullptr)throw;
	else return Node->previous;
}
BlockList::List* BlockList::GetTail()
{
	if (tail==nullptr)throw;
	else return tail;
}
const size_t BlockList::GetSize() const
{
	return this->size;
}
const int BlockList::GetCounter() const
{
	return this->counter;
}
Section& BlockList::operator[](std::size_t index)
{
	List* currentNode = head;
	if (head == nullptr)throw;
	else
	{
		int i = -1, currentIndex = 0;
		do
		{
			if (currentNode->section[currentIndex].Attributes.GetHead() != nullptr)i++;
			if (i == index)break;
			currentIndex++;
			if (currentIndex == (currentNode->section_index))
			{
				if (currentNode->next == nullptr)throw;
				currentNode = currentNode->next;
				currentIndex = 0;

			}

		} while (i != index);
		return currentNode->section[currentIndex];
	}
	
}
const Section& BlockList::operator[](std::size_t index)const
{
	List* currentNode = head;
	if (head == nullptr)throw;
	else
	{
		int i = -1, currentIndex = 0;
		do
		{
			if (currentNode->section[currentIndex].Attributes.GetHead() != nullptr)i++;
			if (i == index)break;
			currentIndex++;
			if (currentIndex == (currentNode->section_index))
			{
				if (currentNode->next == nullptr)throw;
				currentNode = currentNode->next;
				currentIndex = 0;

			}

		} while (i != index);
		return currentNode->section[currentIndex];
	}

}

bool BlockList::IsSectionEmpty(size_t index)
{
	if (this->operator[](index).Attributes.GetHead() == nullptr)return true;
	else
	{
		return false;
	}
}
std::ostream& operator<<(std::ostream& ostr,  BlockList& BL)
{
	for (size_t i = 0; i < BL.GetSize(); i++)
	{
		for (size_t j = 0; j < BL.GetNode(i)->section_index; j++)
		{
			ostr << BL.GetNode(i)->section[j] << std::endl<<std::endl;
		}
	}
	
	return ostr;
}
BlockList::~BlockList()
{
	int realsize = counter;
	for (size_t i = 0; i<realsize; i++)
	{
		PopBack();
	}
}