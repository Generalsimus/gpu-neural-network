#include "cuda_runtime.h"
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

 float* AllocateGpuFloatArray(int size)
{
  //  float* input = (float*)malloc(size * sizeof(float));

    float* d_input;

    cudaMalloc((void**)&d_input, size * sizeof(float));

   // cudaMemcpy(d_input, input, size * sizeof(float), cudaMemcpyHostToDevice);

  //  free(input);

    return d_input;
}

#define cdpErrchk(ans) { cdpAssert((ans), __FILE__, __LINE__); }
 __device__ void cdpAssert(cudaError_t code, const char* file, int line, bool abort = true)
 {
     if (code != cudaSuccess)
     {
         printf("GPU kernel assert: %s %s %d\n", cudaGetErrorString(code), file, line);
         if (abort) assert(0);
     }
 }