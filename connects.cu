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



__global__ void ForwardSigmoid(float* outputs, float* biases) {
    size_t outputIndex = blockIdx.x * blockDim.x + threadIdx.x;

    float value = outputs[outputIndex] + biases[outputIndex];
    
    //1 / (1 + Math.exp(-x));

    outputs[outputIndex] = 1 / (1 + expf(-value));

   // printf("SIGMO outputs[%d]: %.10f :::: %.10f \n", outputIndex, value, outputs[outputIndex]);

};




__global__ void ForwardSum(float* inputs, size_t* inputsSize, float* outputs, size_t* outputsSize, float* widths) {
    size_t outputIndex = blockIdx.y * blockDim.y + threadIdx.y;
    size_t inputIndex = blockIdx.x * blockDim.x + threadIdx.x;
    size_t widthIndex = inputIndex * *outputsSize + outputIndex;


    float bef = outputs[outputIndex];

    //outputs[outputIndex] = outputs[outputIndex] + inputs[inputIndex] * widths[widthIndex];
    atomicAdd(&outputs[outputIndex], inputs[inputIndex] * widths[widthIndex]);

    //printf("outputs[%d]: %.10f :::: %.10f :::: %.10f :::: %.20f \n", outputIndex, outputs[outputIndex], inputs[inputIndex], widths[widthIndex], inputs[inputIndex] * widths[widthIndex]);
   
    //printf("outputs[%d]: %.10f :::: %.10f :::: %.10f \n", outputIndex, outputs[outputIndex], (inputs[inputIndex] * widths[widthIndex]), bef);
};

 


__global__ void ForwardSigmoidDerivative(float* inputs, float* deltas) {
    size_t outputIndex = blockIdx.x * blockDim.x + threadIdx.x;

    float input = inputs[outputIndex];


    //sigmoidX* (1 - sigmoidX);


   //float inputTanh =  (expf(input) - expf(-input)) / (expf(input) + expf(-input))
    //printf("ER: %.5f ::: %.5f \n", deltas[outputIndex], deltas[outputIndex] * (input * (1 - input)));

    deltas[outputIndex] = deltas[outputIndex] * (input * (1 - input));

};



__global__ void TrainError(float* outputs, float* desiredOutputs, float* deltas) {
    size_t outputIndex = blockIdx.x * blockDim.x + threadIdx.x;

  //  printf("outputIndexxxx: %d \n", outputIndex);
    float output = outputs[outputIndex];
    //float outputTanh = tanh(output);
    //sigmoidX* (1 - sigmoidX);

    deltas[outputIndex] = (  (desiredOutputs[outputIndex] - output));

     //printf("ER: %.5f ::: %.5f \n", deltas[outputIndex], (desiredOutputs[outputIndex] - output));
   // printf("errorAs[outputIndex]: %.5f : %.5f : %.5f \n", desiredOutputs[outputIndex], output, (desiredOutputs[outputIndex] - output) * (output * (1 - output)));
};

__global__ void TrainUpdateWidths(float* inputs, size_t* inputsSize, float* outputs, size_t* outputsSize, float* widths, float* biases, float* deltas, float* deltasOutputs, float* learnRate) {
    size_t outputIndex = blockIdx.y * blockDim.y + threadIdx.y;
    size_t inputIndex = blockIdx.x * blockDim.x + threadIdx.x;
    size_t widthIndex = inputIndex * *outputsSize + outputIndex;


    //printf("widths1: %.5f \n", widths[widthIndex]);

    deltasOutputs[inputIndex] += (deltas[outputIndex] * widths[widthIndex]);


    //widths[widthIndex] += *learnRate * (deltas[outputIndex] * inputs[inputIndex]);
    // 
   //printf("DDDD: %d %.5f \n", widthIndex, (*learnRate * (deltas[outputIndex] * inputs[inputIndex])));

    atomicAdd(&widths[widthIndex], (*learnRate * (deltas[outputIndex] * inputs[inputIndex])));
    //atomicAdd(&widths[widthIndex], (*learnRate * (deltas[outputIndex] * outputs[outputIndex])));


    //atomicAdd(&biases[outputIndex], -(*learnRate * deltas[outputIndex]));
    atomicAdd(&biases[outputIndex], (*learnRate * (deltas[outputIndex] * 1)));
    //atomicAdd(&widths[widthIndex], -(*learnRate * (deltas[outputIndex] * inputs[inputIndex])));

    

    //atomicAdd(&deltasOutputs[inputIndex], (deltas[outputIndex] * inputs[inputIndex]));

    //printf("DDDD: %d :::: %.5f :::: %.5f :::: %.5f :::: %.5f \n", inputIndex, deltas[outputIndex], widths[widthIndex], deltasOutputs[inputIndex], (deltas[outputIndex] * widths[widthIndex]));

    //printf("DDDD: %d %.5f \n", inputIndex, deltasOutputs[inputIndex]);


    //printf("widthIndex: %d \n", widthIndex);
    //printf("widths2: %.5f \n", widths[widthIndex]);

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


    CudaMemoryFIll(widths, inputSize * outputSize, 0.50f);
    //////////////////////////////////////////////

    float* biases;
    cudaMalloc((void**)&biases, outputSize * sizeof(float));

    CudaMemoryFIll(biases, outputSize, 1.00f);
    //////////////////////////////////////////////

   
    Connects connects = {
        widths,
        biases,
        blocksPerGrid,
        threadsPerBlock,
    };
     
    return connects;
};


