// Add Two Array.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include<iostream>
#include<conio.h>
#include<stdlib.h>
using namespace std;

void AdditionTwoArray(float *a,float*b,float *c,const int n)
{
	for (int i = 0;i < n;i++)
	{
		c[i] = a[i] + b[i];
	}
}



int main()
{
	float *a, *b, *c;
	const int n = 1024;

	a = (float *)malloc(n * sizeof(float));
	b = (float *)malloc(n * sizeof(float));
	c = (float *)malloc(n *sizeof(float));

	for (int i = 0;i < n;i++)
	{
		a[i]= (rand() / (float)RAND_MAX * 19)+1;
		b[i] = (rand() / (float)RAND_MAX * 19) + 1;
	}
	AdditionTwoArray(a,b,c,n);

	for (int i = 0;i < n;i++)
	{
		cout << "Addition: " << a[i] << " + " << b[i] << " = " << c[i] << endl;
	}

	free(a);
	free(b);
	free(c);

	_getch();
    return 0;
}

