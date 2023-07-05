#include "cuda_runtime.h"

 float* AllocateGpuFloatArray(int size)
{
  //  float* input = (float*)malloc(size * sizeof(float));

    float* d_input;

    cudaMalloc((void**)&d_input, size * sizeof(float));

   // cudaMemcpy(d_input, input, size * sizeof(float), cudaMemcpyHostToDevice);

  //  free(input);

    return d_input;
}
