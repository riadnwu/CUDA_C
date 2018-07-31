
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdio.h>

#include<iostream>
#include<conio.h>
using namespace std;

__global__ void Helloword(void)
{
	printf("Hello Word\n");
}

int main()
{
	Helloword <<< 1, 1000 >>>();
	cudaDeviceReset();
	getch();
	return 0;
}
