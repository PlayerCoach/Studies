#include <stdio.h>

float srednia_harm(float* tablica, unsigned int n);
double new_exp(double x);
double kula(double D, double g, double a, double b);
void  quadratic_eq(double a, double b, double c, double* tab);

int main()
{
	
	double tab[] = { 0, 0 };
	int n = 3;
	float srednia = srednia_harm(tab, n);
	double x = new_exp(3.0);
	double c = kula(40.0, 0.5, 4.0, 5.0);
	quadratic_eq(2.0, -1.0, -15.0, tab);
	

	printf("x1 = %f, x2 = %f", tab[0], tab[1]);
	

	return 0;
}