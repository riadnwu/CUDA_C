
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include<stdio.h>
#include<conio.h>
#include<cuda.h>
#include<iostream>
#include<stdlib.h>
using namespace std;



__global__ void AdditionTwoArray(float *da, float*db, float *dc, const int n)
{
	int i = threadIdx.x;
	if (i < n)
	{
		dc[i] = da[i] + db[i];
		printf("Addition :%f*%f=%f\n", da[i], db[i],dc[i]);
	}
		
}



int main()
{
	float *ha, *hb, *hc;
	float *da, *db, *dc;
	const int n = 1024;
	const int ln = n * sizeof(float);

	ha = (float *)malloc(ln);
	hb = (float *)malloc(ln);
	hc = (float *)malloc(ln);

	for (int i = 0;i < n;i++)
	{
		ha[i] = (rand() / (float)RAND_MAX * 19) + 1;
		hb[i] = (rand() / (float)RAND_MAX * 19) + 1;
		hc[i] = 0;
	}

	cudaMalloc(&da, ln);
	cudaMalloc(&db, ln);
	cudaMalloc(&dc, ln);

	cudaMemcpy(da, ha, ln, cudaMemcpyHostToDevice);
	cudaMemcpy(db, hb, ln, cudaMemcpyHostToDevice);
	cudaMemcpy(dc, hc, ln, cudaMemcpyHostToDevice);

	AdditionTwoArray<<<1,n>>> (da, db, dc, n);

	cudaMemcpy(hc, dc, ln, cudaMemcpyDeviceToHost);

	/*for (int i = 0;i < n;i++)
	{
		//cout << "Addition: " << ha[i] << " + " << hb[i] << " = " << hc[i] << endl;
	}*/

	free(ha);
	free(hb);
	free(hc);
	cudaFree(da);
	cudaFree(db);
	cudaFree(dc);

	cudaDeviceReset();
	_getch();
	return 0;
}

