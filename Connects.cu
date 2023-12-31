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
}

__global__ void ForwardSigmoid(float* outputs, float* biases) { 
    size_t outputIndex = blockIdx.x * blockDim.x + threadIdx.x;

    outputs[outputIndex] = 1.0f / (1.0f + expf(-(outputs[outputIndex] + biases[outputIndex])));
}


__global__ void Train(float* inputs, size_t* inputsSize, float* outputs, size_t* outputsSize, float* widths) {
    size_t outputIndex = blockIdx.y * blockDim.y + threadIdx.y;
    size_t inputIndex = blockIdx.x * blockDim.x + threadIdx.x;
    size_t widthIndex = inputIndex * *outputsSize + outputIndex;


     
}


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


