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

    float* biases = LayerConnect->biases;
    float* widths = LayerConnect->widths;


    for (int outputIndex = 0; outputIndex < outputSize; outputIndex++)
    {

        float outputElement = 0;

        for (int inputIndex = 0; inputIndex < inputSize; inputIndex++)
        {
            float inputElement = input->allocatedInputs[inputIndex];

            int widthIndex = ((inputIndex * outputIndex) + outputIndex);

            outputElement += inputElement * widths[widthIndex];
        };
        (*output).allocatedInputs[outputIndex] = outputElement + biases[outputIndex];
    };
}
// ((inputIndex* OutputIndex) + OutputIndex)


__device__ Connects* CreateConnection(int inputSize, int outputSize)
{
    float* widths;

    cudaMalloc((void**)&widths, inputSize * outputSize * sizeof(float));

    float* biases;

    cudaMalloc((void**)&biases, outputSize * sizeof(float));

    Connects* connects;
    cudaMalloc((void**)&connects, sizeof(Connects));

    (*connects).widths = widths;
    (*connects).biases = biases;

    return connects;
};


__device__ Connects* NewGpuAllocateConnects(int size)
{
    Connects* connect;
    cudaMalloc((void**)&connect, size * sizeof(Connects));
    return connect;
}