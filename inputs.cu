#include "cuda_runtime.h"
#include <corecrt_malloc.h>

typedef struct Inputs
{
    float* allocatedInputs;
    size_t* size;

    dim3 blocksPerGrid;
    dim3 threadsPerBlock;
} Inputs;



void FillInputsDefaultValue(Inputs* inputs, float defaultValue)
{
    /////////////////////////////////////////////////////////////
    float* defaultValueDevice;

    cudaMalloc((void**)&defaultValueDevice, sizeof(float));

    cudaMemcpy(defaultValueDevice, &defaultValue, sizeof(float), cudaMemcpyHostToDevice);
    ///////////////////////////////////////////////////////////// 
    size_t inputSize;


    cudaMemcpy(&inputSize, inputs->size, sizeof(size_t), cudaMemcpyDeviceToHost);
    /////////////////////////////////////////////////////////////

    AllocateArrayInGpuWithDefaultValue<<<inputs->blocksPerGrid, inputs->threadsPerBlock>>>(inputs->allocatedInputs, inputs->size, defaultValueDevice);
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
    size_t thredBalance = FindBalanceThread(size);
     

    dim3 blocksPerGrid(size / thredBalance);
    dim3 threadsPerBlock(thredBalance); 
    ////////////////////////////////
    Inputs input = {
        inputDevice,
        sizeDevice,
        blocksPerGrid,
        threadsPerBlock, 
    };
     
    /////////////////////////////////

    return input;
};

Inputs FloatToInputs(float* inputs,const size_t size)
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
    size_t thredBalance = FindBalanceThread(size);


    dim3 blocksPerGrid(size / thredBalance);
    dim3 threadsPerBlock(thredBalance);
    ////////////////////////////////
    Inputs input = {
        inputDevice,
        sizeDevice,
        blocksPerGrid,
        threadsPerBlock,
    }; 
    return input;
};

void LogInput(Inputs* inputs) {

     LogGpuFloatArray<<<inputs->blocksPerGrid, inputs->threadsPerBlock>>>(inputs->allocatedInputs, inputs->size);
};
