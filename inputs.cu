#include "cuda_runtime.h"
#include "utils.cu"



typedef struct Inputs
{
    float* allocatedInputs;
    int count;
} Inputs;



__device__ Inputs* NewGpuAllocateInputs(int size)
{
    Inputs* inputs;
    cudaMalloc((void**)&inputs, size * sizeof(Inputs));
    return inputs;
};
 
 
