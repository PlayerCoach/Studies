#include "EventHandler.h"

void EventHandler::InputHandler(BlockList& blocklist,String& buffer, char& input,Section& section_buffer,bool& get_selector, bool& get_css,String& name, String& value)
{
	
	if (input != '{' && input != '}'&& input != ';')
	   buffer = buffer + input;
	   String check_for_change(buffer);
	   check_for_change.ToValidString();
	   if (check_for_change == "????")
	   {
		   get_css = false;
		   buffer = "";
	   }
	if (get_css == true)
	{
		if ((input == ',' || input == '{') && get_selector == true)
		{
			this->PushSelector(blocklist, buffer, section_buffer, get_selector, input);
		}
		else if ((input == ':' || input == ';' || input == '}') && get_selector == false)
		{
			this->PushAttribute(blocklist, buffer, section_buffer, get_selector, input, name, value);
		}
	}
}
void EventHandler::PushSelector(BlockList& blocklist,String& buffer, Section& section_buffer, bool& get_selector,char& input)
{
	if (input == '{')get_selector = false;

	buffer.ToValidString();
	if (!(buffer==""))
	section_buffer.Selectors.PushBack(static_cast<String&&>(buffer));
	buffer = "";
}

void EventHandler::PushAttribute(BlockList& blocklist,String& buffer, Section& section_buffer, bool& get_selector, char& input,String& name, String& value)
{
	
	if (input == ':')
	{
		buffer.ToValidString();
		name = buffer;
		buffer = "";
	}
	if (input == ';' || input == '}')
	{
		buffer.ToValidString();
		value = buffer;
		buffer = "";
		if (!(name == "") && !(value == ""))
			section_buffer.Attributes.PushBack(static_cast<Attribute&&>(Attribute{name,value}));
		CheckForDuplicates(section_buffer,name,value);
		name = "";
		value = "";
	}
	if (input == '}')
	{
		get_selector = true;
		blocklist.PushBack(static_cast<Section&&>(section_buffer));
		section_buffer.Selectors.Clear();//clears buffer
		section_buffer.Attributes.Clear();
	}
}
void EventHandler::CheckForDuplicates(Section& section,String& name,String& value)
{
	if (section.Attributes.GetSize()>=2)//chceck if there are at least 2 elements in section array
	{
		for (int i = section.Attributes.GetSize() - 2; i >= 0; i--)
		{

			if(section.Attributes[i].name == name)
			{
				section.Attributes[i].value=value;
				section.Attributes.PopBack();
				break;
			}
		}
	}
}
void EventHandler::CommandHandler(BlockList& blocklist, String& buffer, char& input, Section& section_buffer, bool& get_selector, bool& get_css, String& name, String& value)
{
	if (input != '{' && input != '}' && input != ';')
		buffer = buffer + input;
	if (buffer == "****")
	{
		get_css = true;
		buffer = "";
	}
	if (get_css == false)
	{
		if (input=='\n')
		{
			buffer.ToValidString();
			this->ChooseCommand(blocklist, buffer);
			buffer = "";
		}
	}
}
void EventHandler::ChooseCommand(BlockList& blocklist,String& command_name)
{
	if (command_name == "?")
	{
		HowManyBlocks(blocklist);
	}
	else if(!(command_name==""))
	{
		String fullcomand = command_name;
		String part1 = command_name.CutString();
		String part2 = command_name.CutString();

		if (part2 == "S" && command_name == "?" && part1.IsInt() == true)
			SelectorsInBlock(blocklist, part1, fullcomand);
		else if (part2 == "A" && command_name == "?" && part1.IsInt() == true)
			AttributesInBlock(blocklist, part1, fullcomand);
		else if (part2 == "S" && part1.IsInt() == true && command_name.IsInt() == true)
			GetSelectorInBlock(blocklist, part1, command_name, fullcomand);
		else if (part2 == "A" && part1.IsInt() == true && command_name.IsInt() == false)
			GetAttributeValueInBlock(blocklist, part1, command_name, fullcomand);
		else if (part1.IsInt() == false && part2 == "A" && command_name == "?")
			HowManyAttributes(blocklist, part1, fullcomand);
		else if (part1.IsInt() == false && part2 == "S" && command_name == "?")
			HowManySelectors(blocklist, part1, fullcomand);
		else if (part1.IsInt() == false && part2 == "E" && command_name.IsInt() == false)
			ValueOfAttributeFromSectionZ(blocklist, part1, command_name, fullcomand);
		else if (part1.IsInt() == true && part2 == "D" && command_name == "*")
			DeleteSection(blocklist, part1, fullcomand);
		else if (part1.IsInt() == true && part2 == "D" && command_name.IsInt() == false)
			DeleteAttributeFromSection(blocklist, part1, command_name, fullcomand);

	}

}
void EventHandler::HowManyBlocks(BlockList& blocklist)
{
	std::cout << "? == "<<blocklist.GetCounter()<<std::endl;
}

void EventHandler::SelectorsInBlock(BlockList& blocklist, String& i,String& full_command)
{
	if (i.IsInt() == true)
	{
		int index = i.ToInt();
		if (index <= blocklist.GetCounter() && index >= 1)
		{

			std::cout << full_command << " == " << blocklist[index - 1].Selectors.GetSize() << std::endl;
		}
	}
}

void EventHandler::AttributesInBlock(BlockList& blocklist, String& i, String& full_command)
{
	if (i.IsInt() == true)
	{
		int index = i.ToInt();
		if (index <= blocklist.GetCounter() && index>=1)
		{
			std::cout << full_command << " == " << blocklist[index - 1].Attributes.GetSize() << std::endl;
		}
	}
}

void EventHandler::GetSelectorInBlock(BlockList& blocklist, String& i, String& j, String& full_command)
{
	if (i.IsInt() == true && j.IsInt() == true)
	{
		int index = i.ToInt();
		int jdex = j.ToInt();
		if (index <= blocklist.GetCounter() && index >= 1 && jdex <= blocklist[index - 1].Selectors.GetSize() && jdex >= 1)
		{
			std::cout << full_command << " == " << blocklist[index - 1].Selectors[jdex - 1] << std::endl;
		}
	}
}

void EventHandler::GetAttributeValueInBlock(BlockList& blocklist, String& i, String& name, String& full_command)
{
	if (i.IsInt() == true )
	{
		int index = i.ToInt();
		if (index <= blocklist.GetCounter() && index >= 1)
		{
			DoublyLinkedList<Attribute>::List* node= blocklist[index - 1].Attributes.GetHead();

			while(node!=nullptr)
			{
				if (node->drawer.name == name)
				{
					std::cout << full_command << " == " << node->drawer.value << std::endl;
					break;
				}
				node = node->next;
			}
			
		}
	}
}
void EventHandler::HowManyAttributes(BlockList& blocklist, String& name, String& full_command)
{
	int counter = 0;
	BlockList::List* BigNode = blocklist.GetHead();
	while (BigNode != nullptr)
	{
		for (int i = 0; i < BigNode->section_index; i++)
		{
			DoublyLinkedList<Attribute>::List* node = BigNode->section[i].Attributes.GetHead();
			while (node != nullptr)
			{
				if (node->drawer.name == name)
					counter++;

				node = node->next;
			}

		}
		BigNode = BigNode->next;
	}
	std::cout << full_command << " == " << counter<<std::endl;
}
void EventHandler::HowManySelectors(BlockList& blocklist, String& name, String& full_command)
{
	int counter = 0;
	for (int i = 0; i < blocklist.GetCounter(); i++)
	{

		for (int j = 0; j < blocklist[i].Selectors.GetSize(); j++)
		{
			if (blocklist[i].Selectors[j] == name)
			{
				counter++;
				break;
			}
				
		}

	}
	std::cout << full_command << " == " << counter << std::endl;
}
void EventHandler::ValueOfAttributeFromSectionZ(BlockList& blocklist, String& z, String& name, String& full_command)
{
	String value="";
	for (int i = blocklist.GetCounter()-1; i>=0; i--)
	{

		for (int j = 0; j < blocklist[i].Selectors.GetSize(); j++)
		{
			if (blocklist[i].Selectors[j] == z)
			{
				for (int x = 0; x < blocklist[i].Attributes.GetSize(); x++)
				{
					if (blocklist[i].Attributes[x].name == name)
					{
						value = blocklist[i].Attributes[x].value;
						std::cout << full_command << " == " << value << std::endl;
						return;
					}
				}
			}
			
		}
	}
	
	
}
void EventHandler::DeleteSection(BlockList& blocklist, String& i, String& full_command)
{
	int index = i.ToInt();
	if (index >= 1 && index <= blocklist.GetCounter())
	{
		blocklist.PopOne(index-1);
		std::cout << full_command << " == " << "deleted" << std::endl;
	}
}
void EventHandler::DeleteAttributeFromSection(BlockList& blocklist, String& i, String& name, String& full_command)
{
	int index = i.ToInt();
	if (index >= 1 && index <= blocklist.GetCounter())
	{
		for (int x = 0; x < blocklist[index-1].Attributes.GetSize(); x++)
		{
			if (blocklist[index-1].Attributes[x].name == name)
			{
				if (blocklist[index - 1].Attributes.GetSize() == 1)
				{
					blocklist.PopOne(index - 1);
				}
				else
				{
					blocklist[index - 1].Attributes.PopOne(x);
				}
				
				std::cout << full_command << " == " << "deleted" << std::endl;
				return;
			}
		}
	}
}