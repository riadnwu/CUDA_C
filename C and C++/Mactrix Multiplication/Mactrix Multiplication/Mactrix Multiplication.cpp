#include"stdafx.h"
#include<iostream>
#include<cstdlib>
#include<conio.h>
#include "stdafx.h"
using namespace std;

float** Multiplication(float **a,float **b,float **c,int n)
{
	for (int i = 0;i < n;i++)
	{
		for (int j = 0;j < n;j++)
		{
			for (int k = 0;k < n;k++)
			{
				c[i][j] = c[i][j] +( a[i][k] * b[k][j]);
				cout << "(" << a[i][k] << "*" << b[k][j] << ")";
				if (k != n - 1)cout << "+";
			}
			cout << "\n";
			
		}
		cout << endl;
	}
	return c;
}

int main()
{
	
	int n = 4;
	float **a = (float **)calloc(n,sizeof(float*));
	float **b = (float **)calloc(n,sizeof(float*));
	float **c = (float **)calloc(n, sizeof(float*));

	for (int i = 0;i < n;i++)
	{
		a[i] = (float*)calloc(n, sizeof(float));
		b[i] = (float*)calloc(n, sizeof(float));
		c[i] = (float*)calloc(n, sizeof(float));
	}

	for (int i = 0;i < n;i++)
	{
		for (int j = 0;j < n;j++)
		{
			cin>>a[i][j];
		}
	}
	cout << endl;
	for (int i = 0;i < n;i++)
	{
		for (int j = 0;j < n;j++)
		{
			cin >> b[i][j];
		}
	}
	cout << endl;
	c = Multiplication(a, b, c,n);
	for (int i = 0;i < n;i++)
	{
		for (int j = 0;j < n;j++)
		{
			cout << "c["<<i<<"]["<<j<<"]: " << c[i][j] <<"  ";
		}
		cout << endl;
	}

	free(*a);
	free(*b);
	free(*c);

	_getch();
    return 0;
	
}

/*
Example input for a and b
5 2 6 1
0 6 2 0
3 8 1 4
1 8 5 6
7 5 8 0
1 8 2 6
9 4 3 8
5 3 7 9

Required output of c

96 68 69 69
24 56 18 52
58 95 71 92
90 107 81 142

*/

