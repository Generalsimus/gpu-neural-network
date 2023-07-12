#include "cuda_runtime.h"



typedef struct Inputs
{
    float* allocatedInputs;
    size_t* count;
} Inputs;



void FillInputsDefaultValue(Inputs* inputs, float defaultValue)
{
    /////////////////////////////////////////////////////////////
    float* defaultValueDevice;

    cudaMalloc((void**)&defaultValueDevice, sizeof(float));

    cudaMemcpy(defaultValueDevice, &defaultValue, sizeof(float), cudaMemcpyHostToDevice);
    ///////////////////////////////////////////////////////////// 
    size_t inputSize;


    cudaMemcpy(&inputSize, inputs->count, sizeof(size_t), cudaMemcpyDeviceToHost);
    /////////////////////////////////////////////////////////////

    printf("inputSize: %d \n", inputSize);
    size_t thredBalance = FindBalanceThread(inputSize);


    dim3 blocksPerGrid(inputSize / thredBalance);
    dim3 threadsPerBlock(thredBalance);

    AllocateArrayInGpuWithDefaultValue<<<blocksPerGrid, threadsPerBlock>>>(inputs->allocatedInputs, inputs->count, defaultValueDevice);
    /////////////////////////////////////////////////////////////
};

Inputs NewInputs(size_t size)
{
    ////////////////////////////////
    size_t* sizeDevice;
    cudaMalloc((void**)&sizeDevice, sizeof(size_t));

    cudaMemcpy(sizeDevice, &size, sizeof(size_t), cudaMemcpyHostToDevice);
    ////////////////////////////////  
    float* inputDevice;

    cudaMalloc((void**)&inputDevice, size * sizeof(float));
    ////////////////////////////////
    Inputs input = {
        inputDevice,
        sizeDevice,
    };

    FillInputsDefaultValue(&input, 0.5);
    /////////////////////////////////

    return input;
};

Inputs* FloatToInputs(float* inputs, size_t size)
{
    ////////////////////////////////
    size_t* sizeDevice;

    cudaMalloc((void**)&sizeDevice, sizeof(size_t));

    cudaMemcpy(sizeDevice, &size, sizeof(size_t), cudaMemcpyHostToDevice);
    ////////////////////////////////  
    float* inputDevice;

    cudaMalloc((void**)&inputDevice, size * sizeof(float));

    cudaMemcpy(inputDevice, inputs, size * sizeof(float), cudaMemcpyHostToDevice);
    ////////////////////////////////

    Inputs input = {
        inputDevice,
        sizeDevice,
    };

    return &input;
};
