#include <iostream>
#include <conio.h>
#include "String.h"
#include "SingleLinkedList.h"
#include "DoublyLinkedList.h"
#include "BlockList.h"
#include "Section.h"
#include "Attribute.h"
#include "EventHandler.h"
#include "Swap.h"
#define _CRT_SECURE_NO_WARNINGS
using namespace std;
int main()
{
	BlockList blocklist;
	Section section_buffer;
	char input;
	String buffer;
	String name;
	String value;
	EventHandler EventHandler;
	bool get_selector = true;
	bool get_css = true;
	while ((cin.get(input)) && input!= EOF)
	{
		if (get_css == true)
			EventHandler.InputHandler(blocklist, buffer, input, section_buffer, get_selector, get_css, name, value);
		else
			EventHandler.CommandHandler(blocklist, buffer, input, section_buffer, get_selector, get_css, name, value);
		
	}
	 char endchar = '\n';
	 if (!(buffer.Length() == 0))
	 {
		 if (get_css == true)
			 EventHandler.InputHandler(blocklist, buffer, endchar, section_buffer, get_selector, get_css, name, value);
		 else
			 EventHandler.CommandHandler(blocklist, buffer, endchar, section_buffer, get_selector, get_css, name, value);
	 }
	


	 return 0;
}
