#include "cuda_runtime.h"

typedef struct Inputs
{
    float* allocatedInputs;
    int count;
} Inputs;



__device__ Inputs* NewGpuAllocateInputs(int size)
{
    Inputs* inputs;
    cudaMalloc(&inputs, size * sizeof(Inputs));
    return inputs;
};

__device__ Inputs* NewGpuAllocateSingleInputs(int size)
{

    float* inputsValues;

    cudaMalloc(&inputsValues, size * sizeof(float));

    Inputs* inputs;
    cudaMalloc(&inputs, sizeof(Inputs));

    (*inputs).allocatedInputs = inputsValues;
    (*inputs).count = size;

    return inputs;
};