// cuda.cu
#include <stdio.h>
#include <cuda.h>

__global__ void cudaKernel() {
    printf("Hello from CUDA kernel!\n");
}

extern "C" {
     void runCudaCode() {
        cudaKernel<<<1, 1>>>();
        cudaDeviceSynchronize();
    }
}