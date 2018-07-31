
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include<iostream>
#include<cstdlib>
#include<conio.h>
#include <stdio.h>
#include <math.h>
#define blockSize 4
using namespace std;

__global__ void Addition(float *ad, float *bd, float *cd, const int n)
{
	unsigned int i = blockSize*blockIdx.x + threadIdx.x;
	unsigned int j = blockSize*blockIdx.y + threadIdx.y;

	if (i < n && j < n)
	{
		cd[i + j*n] = ad[i + j*n] + bd[i + j*n];
	}
}

int main()
{
	const int n = 4;
	float ah[n][n], bh[n][n], ch[n][n];
	float *ad, *bd, *cd;

	for (int i = 0; i<n; i++)
	{
		for (int j = 0; j<n; j++)
		{
			cin >> ah[i][j];
		}
	}

	for (int i = 0; i<n; i++)
	{
		for (int j = 0; j<n; j++)
		{
			cin >> bh[i][j];
		}
	}


	cudaMalloc((void **)&ad, n*n*sizeof(int));
	cudaMalloc((void **)&bd, n*n*sizeof(int));
	cudaMalloc((void **)&cd, n*n*sizeof(int));


	cudaMemcpy(ad, ah, n*n*sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(bd, bh, n*n*sizeof(int), cudaMemcpyHostToDevice);


	dim3 dimGrid(n / blockSize, n / blockSize, 1);
	dim3 dimBlock(blockSize, blockSize, 1);

	Addition << <dimGrid, dimBlock >> > (ad, bd, cd, n);

	cudaMemcpy(ch, cd, n*n*sizeof(int), cudaMemcpyDeviceToHost);

	for (int i = 0; i<n; i++)
	{
		for (int j = 0; j < n; j++)
		{
			cout << ch[i][j] << " ";
		}
		cout << "\n";
	}
	getch();

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

12 7 14 1
1 14 4 6
12 12 4 12
6 11 12 15

*/

