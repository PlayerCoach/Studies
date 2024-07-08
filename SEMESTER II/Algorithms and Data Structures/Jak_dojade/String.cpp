#define _CRT_SECURE_NO_WARNINGS
#include "String.h"



String::String()
	:string{ nullptr }
{
	string = new char[1];
	string[0] = '\0';

}
String::String(const char* word)
{
	if (word == nullptr)
	{
		string = new char[1];
		string[0] = '\0';
	}
	else
	{
		string = new char[strlen(word) + 1];
		strcpy(string, word);
		string[strlen(word)] = '\0';
	}
}
String::String(const String& source)
{
	string = new char[strlen(source.string) + 1];
	strcpy(string, source.string);
	string[strlen(source.string)] = '\0';
}
 String::String(String&& toMove) noexcept
	
{
	 string = toMove.string;
	 toMove.string = nullptr;
}
 String& String::operator=(const String& other) noexcept
 {
	 String temp(other);
	 Swap(string, temp.string);
	 return *this;
 }
 String& String::operator=(String&& other) noexcept
 {
	 
	 Swap(string, other.string);
	 return *this;

 }
 int String:: Length() const
 {
	 int length = 0;
	 while (this->string[length] != '\0')
	 {
		 length++;
	 }
	 return length;
 }
 bool String::operator==(const String& other) const
 {
	 int length1 = Length();
	 int length2 = other.Length();
	 if (length1 != length2) return false;
	 else
	 {
		 for (int i = 0; i < length1; i++)
		 {
			 if (string[i] != other.string[i])return false;
		 }
		 return true;
	 }
 }
 String String::operator+(const String& other)const
 {
	int length1 = Length();
	int length2 = other.Length();
	char* newString = new char[length1 + length2 + 1];
	for (int i = 0; i < length1 + length2 + 1; i++)
	{
		if (i < length1)
		{
			newString[i] = string[i];
		}
		else if (i >= length1 && i < length1+length2)
		{
			newString[i] = other.string[i-length1];
		}
		else if (i == (length1 + length2))
		{
			newString[i] = '\0';
		}
	}
	String result(static_cast<char*&&>(newString));
	delete[] newString;
	return result;
	
 }
 String String::operator+(const char& other)const
 {
	 int length1 = Length();
	 char* newString = new char[length1+2];
	 for (int i = 0; i < length1; i++)
	 {
			 newString[i] = string[i];
	 }
	 newString[length1] = other;
	 newString[length1 + 1] = '\0';
	 String result(static_cast<char*&&>(newString));
	 delete[] newString;
	 return result;

 }
 const char String::operator[](int index)const
 {
	 if (index >= strlen(string))throw;
	 return string[index];
 }
 char String::operator[](int index)
 {
	  if (index >= strlen(string))throw;
	 return string[index];
 }
 int String::ToInt()const
 {
	 int length = Length();
	 int result = 0;
	 for (int i = 0; i < length; i++)
	 {
		 if (string[i] < '0' || string[i]>'9')
		 {
			 std::cout << "Invalid format, please eneter decimal value" << std::endl;
			 return -1;
		 }
		 else
		 {
			 result += (int(string[i] - '0') * pow(10, length-i-1));
		 }
	 }
	 return result;
 }
 bool String::IsInt()const
 {
	 int length = Length();
	 for (int i = 0; i < length; i++)
	 {
		 if (string[i] < '0' || string[i]>'9')return false; 
	 }
	 return true;
 }
 String String::GetString()const
 {
	 return string;
 }
 void String::Reverse()
 {
	 int length = Length();

	for (int i = 0; i < length / 2; i++)
		Swap(string[i], string[length - i-1]);
 }
 std::ostream& operator<<(std::ostream& ostr, const String& s)
 {
	 int i = 0;
	 while (s.string[i] != '\0')
	 {
		 ostr << s.string[i];
		 i++;
	 }
	 return ostr;
 }
 void String::ToValidString()
 {
	 bool flag = true;
	 int frontCut = 0;
	 while ((string[frontCut] <= ' ')
		 || (string[frontCut] == '\n'))
	 {
		 if (string[frontCut] == '\0')
		 {
			 flag = false;
			 char* ValidString = new char[1];
			 ValidString[0] = '\0';
			 delete[]string;
			 string = ValidString;
		 }
		 frontCut++;
	 }
	 if (flag == true)
	 {
		 int backCut = 0;
		 int stringlength = strlen(string);
		 while ((string[stringlength - backCut - 1] <= ' ')
			 || (string[stringlength - backCut - 1]) == '\n')
		 {
			 backCut++;
		 }
		 char* ValidString = new char[stringlength - backCut - frontCut + 1];
		 memcpy(ValidString, (string + frontCut), stringlength - backCut - frontCut);
		 ValidString[stringlength - backCut - frontCut] = '\0';
		 delete[]string;
		 string = ValidString;
	 }

 }

 String String::CutString()
 {
	 String Cut;
	 int CutCounter = 0;
	 this->ToValidString();
	 while (!(string[CutCounter] == ' '))
	 {
		 Cut = Cut + string[CutCounter];
		 CutCounter++;
		 if (string[CutCounter] == '\0')return string;
	 }
	 char* ValidString = new char[strlen(string) - CutCounter + 1];
	 memcpy(ValidString, (string + CutCounter + 1), strlen(string) - CutCounter);
	 ValidString[strlen(string) - CutCounter] = '\0';
	 delete[]string;
	 string = ValidString;
	 return Cut;

 }
String::~String()
{
	delete[] string;
}
