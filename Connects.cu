#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <corecrt_math.h>

typedef struct Connects
{
    float* widths;
    float* biases;

    dim3 blocksPerGrid;
    dim3 threadsPerBlock;

} Connects;


__global__ void ForwardSum(float* inputs, size_t* inputsSize, float* outputs, size_t* outputsSize, float* widths) {
     size_t outputIndex = blockIdx.y * blockDim.y + threadIdx.y;
     size_t inputIndex = blockIdx.x * blockDim.x + threadIdx.x;
     size_t widthIndex = inputIndex * *outputsSize + outputIndex;

      

     outputs[outputIndex] += inputs[inputIndex] * widths[widthIndex];

    // printf("widthIndex = %d\n", inputIndex * *outputsSize + outputIndex);
    // widths[inputIndex * *outputsSize + outputIndex]
    // printf("Thread %d: Width value = %.2f\n", inputIndex * *outputsSize + outputIndex, widths[inputIndex * *outputsSize + outputIndex]);
    // printf("Thread %d: outputIndex value = %.2f\n", outputIndex, outputs[outputIndex]);
    // printf("Thread %d: inputIndex value = %.2f\n", inputIndex, inputs[inputIndex]);
    // printf("Thread %d: Input value = %.2f\n", inputIndex, outputs[outputIndex]);



}

__global__ void ForwardSigmoid(float* inputs, size_t* inputsSize, float* outputs, size_t* outputsSize, float* widths) {
    size_t outputIndex = blockIdx.y * blockDim.y + threadIdx.y;
    //size_t inputIndex = blockIdx.x * blockDim.x + threadIdx.x;/*
    //size_t widthIndex = inputIndex * *outputsSize + outputIndex;*/

    outputs[outputIndex] = 1.0f / (1.0f + expf(-outputs[outputIndex]));
}
//__device__ void Forward(Connects* LayerConnect, Inputs* input, Inputs* output)
//{
//
//    int outputSize = output->count;
//    int inputSize = input->count;
//
//    float* biases = LayerConnect->biases;
//    float* widths = LayerConnect->widths;
//
//
//    for (int outputIndex = 0; outputIndex < outputSize; outputIndex++)
//    {
//
//        float outputElement = 0;
//
//        for (int inputIndex = 0; inputIndex < inputSize; inputIndex++)
//        {
//            float inputElement = input->allocatedInputs[inputIndex];
//
//            int widthIndex = ((inputIndex * outputIndex) + outputIndex);
//
//            outputElement += inputElement * widths[widthIndex];
//        };
//        (*output).allocatedInputs[outputIndex] = outputElement + biases[outputIndex];
//    };
//}
// ((inputIndex* OutputIndex) + OutputIndex)

Connects NewConnection(size_t inputSize, size_t outputSize)
{
    /////////////////////////////////////////////
    size_t inputThredBalance = FindBalanceThread(inputSize);
    size_t outputThredBalance = FindBalanceThread(outputSize);


    dim3 blocksPerGrid(inputSize / inputThredBalance, outputSize / outputThredBalance);
    dim3 threadsPerBlock(inputThredBalance, outputThredBalance);
    /////////////////////////////////////////////

    float* widths;
    cudaMalloc((void**)&widths, inputSize * outputSize * sizeof(float));

    //////////////////////////////////////////////

    float* biases;
    cudaMalloc((void**)&biases, outputSize * sizeof(float));

    //////////////////////////////////////////////

   
    Connects connects = {
        widths,
        biases,
        blocksPerGrid,
        threadsPerBlock,
    };
     
    return connects;
};


