
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include<iostream>
#include<cstdlib>
#include<conio.h>
#include <stdio.h>
#include <math.h>
#define blockSize 4
using namespace std;

__global__ void MatrixMul(float *ad, float *bd, float *cd, const int n)
{
	unsigned int i = blockSize*blockIdx.x + threadIdx.x;
	unsigned int j = blockSize*blockIdx.y + threadIdx.y;

	for (int k = 0; k<n; k++)
	{
		cd[ i+ j*n] += ad[j * n + k] * bd[i + k * n ];
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
			cin>>ah[i][j];
		}
	}

	for (int i = 0; i<n; i++)
	{
		for (int j = 0; j<n; j++)
		{
			cin>>bh[i][j];
		}
	}


	cudaMalloc((void **)&ad, n*n*sizeof(int));
	cudaMalloc((void **)&bd, n*n*sizeof(int));
	cudaMalloc((void **)&cd, n*n*sizeof(int));


	cudaMemcpy(ad, ah, n*n*sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(bd, bh, n*n*sizeof(int), cudaMemcpyHostToDevice);


	dim3 dimBlock(blockSize, blockSize, 1);
	dim3 dimGrid(n / blockSize, n / blockSize, 1);
	
   MatrixMul << <dimGrid, dimBlock >> > (ad, bd, cd, n);

   cudaMemcpy(ch, cd, n*n*sizeof(int),cudaMemcpyDeviceToHost);

	for (int i = 0; i<n; i++)
	{
		for (int j = 0; j < n; j++)
		{
			cout<< ch[i][j]<<" ";
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

96 68 69 69
24 56 18 52
58 95 71 92
90 107 81 142

*/

