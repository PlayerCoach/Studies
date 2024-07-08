#include <stdio.h>
int szukaj_abs_min(int tabl[], int n);


int main()
{

	int tab[] = { 2, -1, 3 , 0, 12, 17, 19 };
	int length = sizeof(tab)/sizeof(int);
	 int value = szukaj_abs_min(tab, length);
	printf("%d ", value);
	


	return 0;
}