#pragma once
#include "BlockList.h"
#include "String.h"

class EventHandler
{

public:
	
	void InputHandler(BlockList& blocklist,String& buffer, char& input, Section& section_buffer, bool& get_selector, bool& get_css,String& name,String& value);//function to create string called buffer
	void PushSelector(BlockList& blocklist,String& buffer, Section& section_buffer, bool& get_selector, char& input);//function to pushback buffer to selector list
	void PushAttribute(BlockList& blocklist,String& buffer, Section& section_buffer, bool& get_selector, char& input,String& name, String& value);
	void CheckForDuplicates(Section& section,String& name, String& value);
	void CommandHandler(BlockList& blocklist, String& buffer, char& input, Section& section_buffer, bool& get_selector, bool& get_css, String& name, String& value);
	void ChooseCommand(BlockList& blocklist, String& command_name);
	void HowManyBlocks(BlockList& blocklist);
	void SelectorsInBlock(BlockList& blocklist, String& i,String& full_command);
	void AttributesInBlock(BlockList& blocklist, String& i, String& full_command);
	void GetSelectorInBlock(BlockList& blocklist, String& i, String& j, String& full_command);
	void GetAttributeValueInBlock(BlockList& blocklist, String& i, String& name, String& full_command);
	void HowManyAttributes(BlockList& blocklist,String& name, String& full_command);
	void HowManySelectors(BlockList& blocklist, String& name, String& full_command);
	void ValueOfAttributeFromSectionZ(BlockList& blocklist, String& z, String& name, String& full_command);
	void DeleteSection(BlockList& blocklist,String& i,String& full_command);
	void DeleteAttributeFromSection(BlockList& blocklist, String& i, String& name, String& full_command);
};


