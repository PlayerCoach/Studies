#include <stdio.h>
int szukaj_max(int a, int b, int c);
int szukaj_max_cztery(int a, int b, int c, int d);
void plus_jeden(int* a);
void liczba_przeciwna(int* a);
void odejmij_jeden(int** a);
void przestaw(int tabl[], int n);

int main()
{
	// Zadanie 4.1 //

	/*int a, b, c, d, wynik;
	printf("\nProsze podac cztery liczby calkowite ze znakiem: ");
	scanf_s("%d %d %d %d", &a, &b, &c, &d);
	wynik = szukaj_max_cztery(a, b, c, d);
	printf("\nSposrod podanych liczb %d, %d, %d, %d liczba %d jest najwieksza\n", a, b, c, d,  wynik);
	return 0;*/

	// Zadanie 4.2 //

	/*int m;
	m = -17;
	liczba_przeciwna(&m);
	printf("\n m = %d\n", m);*/

	// Zadanie 4.3 //

	/*int k;
	int* wsk;
	wsk = &k;
	printf("\nProsze napisac liczbe: ");
	scanf_s("%d", &k, 12);
	odejmij_jeden(&wsk);
	printf("\nWynik = %d\n", k);*/

	// Zadanie 4.4 //
	int tab[12] = { 12,11,10,9,8,7,6,5,4,3,2,1 };
	int length = 12;
	for (int i = 0; i < (sizeof(tab) / sizeof(tab[0])); i++)
	{
		printf("%d ", tab[i]);
	}
	printf("\n");
	for (int i = 0; i < length - 1 ; i++)
	{
		przestaw(tab, (length - i));
	}
	printf(" Posortowana tablica: \n");
	for (int i = 0; i < (sizeof(tab) / sizeof(tab[0])); i++)
	{
		printf("%d ", tab[i]);
	}

	return 0;
}