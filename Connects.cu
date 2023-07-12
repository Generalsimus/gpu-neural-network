#include "utils.cu"
#include "cuda_runtime.h"
#include "device_launch_parameters.h"


typedef struct Connects
{
    float* widths;
    float* biases;
    dim3 blocksPerGrid;
    dim3 threadsPerBlock;
} Connects;


__global__ void ForwardSum(float* inputs, size_t* inputsSize, float* outputs, size_t* outputsSize, float* widths) {
    int outputIndex = blockIdx.y * blockDim.y + threadIdx.y; 
    int inputIndex = blockIdx.x * blockDim.x + threadIdx.x;

    printf("outputIndex: %d ,inputIndex: %d \n", outputIndex, inputIndex); 

    printf("Float value: %f\n", inputs[inputIndex]);

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


