
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
		cd[i + j*n] += ad[j * n + k] * bd[i + k * n];
	}
}

int main()
{
	const int n = 4;
	float ah3[n][n][n], bh3[n][n][n], ch3[n][n][n];
	float ah[n*n][n], bh[n*n][n], ch[n+n][n];
	float *ad, *bd, *cd;

	for (int i = 0; i<n; i++)
	{
		for (int j = 0; j<n; j++)
		{
			for (int k = 0;k < n;k++)
			{
				ah3[i][j][k] = i + 1;
				ah[i+(k+1)*(k + 1)][j] = ah3[i][j][k]; // Covert TMA(3) to G2A
				bh3[i][j][k] = j + 1;
			}
		}
	}

	
// Show G2A
	for (int i = 0; i < n * n; i++)
	{
		for (int j = 0; j < n; j++)
		{
			cout << ah[i][j];
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


