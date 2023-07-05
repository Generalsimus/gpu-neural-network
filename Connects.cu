#include "cuda_runtime.h"

typedef struct Connects
{
    float* widths;
    float* biases;
} Connects;

__device__ void Forward(Connects* LayerConnect, Inputs* input, Inputs* output)
{

    int outputSize = output->count;
    int inputSize = input->count;
    // float *widths = LayerConnect.widths;
    float* biases = LayerConnect->biases;
    // printf("outputSize: %d\n", outputSize);
    // printf("inputSize: %d\n", inputSize);

    for (int outputIndex = 0; outputIndex < outputSize; outputIndex++)
    {
      //  printf("Aa: %d\n", outputIndex);
        float outputElement = 0;

        for (int inputIndex = 0; inputIndex < inputSize; inputIndex++)
        {
            float inputElement = input->allocatedInputs[inputIndex];
            outputElement += inputElement * (outputIndex * inputSize + inputIndex);
        };
        (*output).allocatedInputs[outputIndex] = outputElement + biases[outputIndex];
    };
}


__device__ Connects* CreateConnection(int inputSize, int outputSize)
{
    float* widths;

    cudaMalloc(&widths, inputSize * outputSize * sizeof(float));

    float* biases;

    cudaMalloc(&biases, outputSize * sizeof(float));

    Connects* devicePtr;
    cudaMalloc(&devicePtr, sizeof(Connects));

    (*devicePtr).widths = widths;
    (*devicePtr).biases = biases;

    return devicePtr;
};


__device__ Connects* NewGpuAllocateConnects(int size)
{
    Connects* connect;
    cudaMalloc(&connect, size * sizeof(Connects));
    return connect;
}