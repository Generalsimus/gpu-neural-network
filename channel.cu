#include "inputs.cu"
#include "connects.cu"
#include <cuda_runtime.h>


typedef struct Channel
{
    Inputs* allocatedOutputs;
    Connects* allocatedConnects;
    int outputLayerSize;
    int layersCount;
} Channel;

__global__ void ForWards(Channel* chan, Inputs* forwardInput)
{ 
};

void AddOutputInput(Channel* chan, int inputSize)
{
    int layersCount = chan->layersCount;
    printf("layersCount: %d \n", layersCount);
     
    if (layersCount > 0){

        int connectsCount = layersCount - 1; 

        ////////////////////////////////////////////////////////////////////////////
        Inputs* allocatedOutputs = (Inputs*)malloc(inputSize * sizeof(Inputs));


        for (int outputIndex = 0; outputIndex < connectsCount; outputIndex++)
        { 
            allocatedOutputs[outputIndex] = chan->allocatedOutputs[outputIndex];
        };

        float* inputsValues = (float*)malloc(inputSize * sizeof(float));

        Inputs newInputs = {
        inputsValues,
        inputSize, 
        };
        allocatedOutputs[connectsCount] = newInputs; 
        chan->allocatedOutputs = allocatedOutputs; 
        ////////////////////////////////////////////////////////////////////////////


        Connects* allocatedConnects = (Connects*)malloc(inputSize * sizeof(Connects));
         
        
       

        for (int connectIndex = 0; connectIndex < connectsCount; connectIndex++)
        {
            allocatedConnects[connectIndex] = chan->allocatedConnects[connectIndex];
        };
        int connectsSize = chan->outputLayerSize * inputSize;
        float* widths = (float*)malloc(connectsSize * sizeof(float));
        float* biases = (float*)malloc(inputSize * sizeof(float));
        Connects newConnect = {
        widths,
        biases,
        };
        allocatedConnects[connectsCount] = newConnect;

        chan->allocatedConnects = allocatedConnects;
         
    }


    chan->outputLayerSize = inputSize;
    chan->layersCount = layersCount + 1; 


    printf("ENDDDDDDDDDDDDDD \n" );

    // #if __CUDA_ARCH__ >= 200
    //     printf("inputSize: %d \n", inputSize);
    //
    // #endif
    //     int layersCount = chan->layersCount;
    //
    //     if (layersCount > 0)
    //     {
    //         int connectsCount = layersCount - 1;
    //
    //         ////////////////////////////////////////////////////////
    //         Inputs* allocatedOutputs = NewGpuAllocateInputs(layersCount);
    //
    //         for (int outputIndex = 0; outputIndex < connectsCount; outputIndex++)
    //         {
    //
    //             allocatedOutputs[outputIndex] = chan->allocatedOutputs[outputIndex];
    //         };
    //
    //         Inputs* newInputsElement = NewGpuAllocateSingleInputs(inputSize);
    //
    //         for (int outputIndex = 0; outputIndex < newInputsElement->count; outputIndex++)
    //         {
    // #if __CUDA_ARCH__ >= 200
    //             printf("wwwwwww: %d \n", outputIndex);
    // #endif
    //         }
    //         //   allocatedOutputs[connectsCount] = *newInputsElement;
    //         //   (*chan).allocatedOutputs = allocatedOutputs;
    //
    //         ////////////////////////////////////////////////////////
    //
    //         //  Connects* allocatedConnects = NewGpuAllocateConnects(layersCount);
    //
    //         //  for (int connectIndex = 0; connectIndex < connectsCount; connectIndex++)
    //         // {
    //         //     allocatedConnects[connectIndex] = chan->allocatedConnects[connectIndex];
    //         //  };
    //
    //         //   Connects* connects = CreateConnection((*chan).outputLayerSize, inputSize);
    //         //    allocatedConnects[connectsCount] = *connects;
    //
    //         //  (*chan).allocatedConnects = allocatedConnects;
    //
    //         ////////////////////////////////////////////////////////
    //         // }
    //     };
    //
    //     (*chan).outputLayerSize = inputSize;
    //     (*chan).layersCount = layersCount + 1;
    //
    //     //  cudaDeviceSynchronize();
    //     // for (int outputIndex = 0; outputIndex < outputSize; outputIndex++)
    //     //  {
    //     //  }/
}; 