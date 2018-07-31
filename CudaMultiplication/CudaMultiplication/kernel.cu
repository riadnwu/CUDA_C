
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdlib.h>

#include <stdio.h>

#define N 16



// Kernel definition

__global__ void MatAdd(float A[N][N], float B[N][N],float C[N][N])

{

	int i = threadIdx.x;

	int j = threadIdx.y;

	C[i][j] = A[i][j] + B[i][j];

}

int main()

{

	float *A, *B, *C;

	cudaMalloc((void**)&A, sizeof(float) * N * N);

	cudaMalloc((void**)&B, sizeof(float) * N * N);

	cudaMalloc((void**)&C, sizeof(float) * N * N);

	// Kernel invocation

	dim3 dimBlock(N, N);

	MatAdd << <1, dimBlock >> >((float(*)[16])A, (float(*)[16])B, (float(*)[16])C);

	if (cudaGetLastError() != cudaSuccess)

		printf("kernel launch failed\n");

	cudaThreadSynchronize();

	if (cudaGetLastError() != cudaSuccess)

		printf("kernel execution failed\n");

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
