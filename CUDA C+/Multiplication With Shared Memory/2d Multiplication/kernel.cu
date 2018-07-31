
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include<iostream>
#include<cstdlib>
#include<conio.h>
#define TILE_WIDTH 2
#include <stdio.h>
#include <math.h>
using namespace std;

/*matrix multiplication kernels*/

//non shared
__global__ void
MatrixMul(float *Md, float *Nd, float *Pd, const int WIDTH)
{

	// calculate thread id

	unsigned int col = TILE_WIDTH*blockIdx.x + threadIdx.x;

	unsigned int row = TILE_WIDTH*blockIdx.y + threadIdx.y;

	for (int k = 0; k<WIDTH; k++)
	{
		Pd[row*WIDTH + col] += Md[row * WIDTH + k] * Nd[k * WIDTH + col];
	}
}

// shared
__global__ void
MatrixMulSh(float *Md, float *Nd, float *Pd, const int WIDTH)
{

	//Taking shared array to break the MAtrix in Tile widht and fatch them in that array per ele

	__shared__ float Mds[TILE_WIDTH][TILE_WIDTH];

	__shared__ float Nds[TILE_WIDTH][TILE_WIDTH];

	// calculate thread id
	unsigned int col = TILE_WIDTH*blockIdx.x + threadIdx.x;
	unsigned int row = TILE_WIDTH*blockIdx.y + threadIdx.y;

	for (int m = 0; m<WIDTH / TILE_WIDTH; m++) // m indicate number of phase
	{
		Mds[threadIdx.y][threadIdx.x] = Md[row*WIDTH + (m*TILE_WIDTH + threadIdx.x)];
		Nds[threadIdx.y][threadIdx.x] = Nd[(m*TILE_WIDTH + threadIdx.y) * WIDTH + col];

		for (int k = 0; k<TILE_WIDTH; k++)
			Pd[row*WIDTH + col] += Mds[threadIdx.x][k] * Nds[k][threadIdx.y];

	}
}

// main routine
int main()
{
	const int n = 6;
	float array1_h[n][n], array2_h[n][n], result_array_h[n][n], M_result_array_h[n][n];
	float *array1_d, *array2_d, *result_array_d, *M_result_array_d; // device array
	int i, j;
	//input in host array
	for (i = 0; i<n; i++)
	{
		for (j = 0; j<n; j++)
		{
			array1_h[i][j] = 1;
			array2_h[i][j] = 2;
		}
	}

	//create device array cudaMalloc ( (void **)&array_name, sizeofmatrixinbytes) ;

	cudaMalloc((void **)&array1_d, n*n*sizeof(int));

	cudaMalloc((void **)&array2_d, n*n*sizeof(int));



	//copy host array to device array; cudaMemcpy ( dest , source , WIDTH , direction )

	cudaMemcpy(array1_d, array1_h, n*n*sizeof(int), cudaMemcpyHostToDevice);

	cudaMemcpy(array2_d, array2_h, n*n*sizeof(int), cudaMemcpyHostToDevice);



	//allocating memory for resultent device array

	cudaMalloc((void **)&result_array_d, n*n*sizeof(int));

	cudaMalloc((void **)&M_result_array_d, n*n*sizeof(int));



	//calling kernal

	dim3 dimGrid(n / TILE_WIDTH, n / TILE_WIDTH, 1);

	dim3 dimBlock(TILE_WIDTH, TILE_WIDTH, 1);

	// Change if 0 to if 1 for running non shared code and make if 0 for shared memory code
#if 0

	MatrixMul << <dimGrid, dimBlock >> > (array1_d, array2_d, M_result_array_d, WIDTH);

#endif

#if 1

	MatrixMulSh << <dimGrid, dimBlock >> > (array1_d, array2_d, M_result_array_d, WIDTH);

#endif

	// all gpu function blocked till kernel is working
	//copy back result_array_d to result_array_h

	cudaMemcpy(M_result_array_h, M_result_array_d, n*n*sizeof(int),
		cudaMemcpyDeviceToHost);

	//printf the result array
	for (i = 0; i<n; i++)
	{
		for (j = 0; j < n; j++)
		{
			printf("%f   ", M_result_array_h[i][j]);
		}
		printf("\n");
	}
	system("pause");
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

