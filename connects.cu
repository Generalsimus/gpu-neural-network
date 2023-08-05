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



__global__ void ForwardTanh(float* outputs, float* biases) {
    size_t outputIndex = blockIdx.x * blockDim.x + threadIdx.x;

    float value = outputs[outputIndex] + biases[outputIndex];
    
    outputs[outputIndex] = (expf(value) - expf(-value)) / (expf(value) + expf(-value));
};




__global__ void ForwardSum(float* inputs, size_t* inputsSize, float* outputs, size_t* outputsSize, float* widths) {
    size_t outputIndex = blockIdx.y * blockDim.y + threadIdx.y;
    size_t inputIndex = blockIdx.x * blockDim.x + threadIdx.x;
    size_t widthIndex = inputIndex * *outputsSize + outputIndex;



    outputs[outputIndex] += inputs[inputIndex] * widths[widthIndex];
};

__global__ void ForwardSigmoid(float* outputs, float* biases) {
    size_t outputIndex = blockIdx.x * blockDim.x + threadIdx.x;

    outputs[outputIndex] = 1.0f / (1.0f + expf(-(outputs[outputIndex] + biases[outputIndex])));
};


__global__ void ForwardSigmoidDerivative(float* inputs, float* deltas) {
    size_t outputIndex = blockIdx.x * blockDim.x + threadIdx.x;

    float input = inputs[outputIndex];

    deltas[outputIndex] = deltas[outputIndex] * (input * (1 - input));
};



__global__ void TrainError(float* outputs, float* desiredOutputs, float* errorAs) {
    size_t outputIndex = blockIdx.x * blockDim.x + threadIdx.x;

  //  printf("outputIndexxxx: %d \n", outputIndex);
    float output = outputs[outputIndex];

    errorAs[outputIndex] = (desiredOutputs[outputIndex] - output) * (output * (1 - output));

   // printf("errorAs[outputIndex]: %.5f : %.5f : %.5f \n", desiredOutputs[outputIndex], output, (desiredOutputs[outputIndex] - output) * (output * (1 - output)));
};

__global__ void TrainUpdateWidths(float* inputs, size_t* inputsSize, float* outputs, size_t* outputsSize, float* widths, float* biases, float* deltas, float* deltasOutputs, float* learnRate) {
    size_t outputIndex = blockIdx.y * blockDim.y + threadIdx.y;
    size_t inputIndex = blockIdx.x * blockDim.x + threadIdx.x;
    size_t widthIndex = inputIndex * *outputsSize + outputIndex;


    //printf("widths1: %.5f \n", widths[widthIndex]);

    widths[widthIndex] -= (deltas[outputIndex] * *learnRate * inputs[inputIndex]);


    //printf("widths2: %.5f \n", widths[widthIndex]);

    deltasOutputs[inputIndex] += (deltas[outputIndex] * widths[widthIndex]);
};



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


