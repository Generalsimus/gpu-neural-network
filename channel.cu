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
    for (int connectIndex = 0; connectIndex < ((*chan).layersCount - 1); connectIndex++)
    {

        Connects connect = (*chan).allocatedConnects[connectIndex];
        Inputs outputs = (*chan).allocatedOutputs[connectIndex];

        Forward(&connect, forwardInput, &outputs);

        *forwardInput = outputs;
    }
};

__global__ void AddOutputInput(Channel* chan, int inputSize)
{
#if __CUDA_ARCH__ >= 200
    printf("inputSize: %d \n", inputSize);

#endif
    int layersCount = chan->layersCount;

    if (layersCount > 0)
    {
        int connectsCount = layersCount - 1;

        ////////////////////////////////////////////////////////
        Inputs* allocatedOutputs = NewGpuAllocateInputs(layersCount);

        for (int outputIndex = 0; outputIndex < connectsCount; outputIndex++)
        {

            allocatedOutputs[outputIndex] = chan->allocatedOutputs[outputIndex];
        };

        Inputs* newInputsElement = NewGpuAllocateSingleInputs(inputSize);

        for (int outputIndex = 0; outputIndex < newInputsElement->count; outputIndex++)
        {
#if __CUDA_ARCH__ >= 200
            printf("wwwwwww: %d \n", outputIndex);
#endif
        }
        //   allocatedOutputs[connectsCount] = *newInputsElement;
        //   (*chan).allocatedOutputs = allocatedOutputs;

        ////////////////////////////////////////////////////////

        //  Connects* allocatedConnects = NewGpuAllocateConnects(layersCount);

        //  for (int connectIndex = 0; connectIndex < connectsCount; connectIndex++)
        // {
        //     allocatedConnects[connectIndex] = chan->allocatedConnects[connectIndex];
        //  };

        //   Connects* connects = CreateConnection((*chan).outputLayerSize, inputSize);
        //    allocatedConnects[connectsCount] = *connects;

        //  (*chan).allocatedConnects = allocatedConnects;

        ////////////////////////////////////////////////////////
        // }
    };

    (*chan).outputLayerSize = inputSize;
    (*chan).layersCount = layersCount + 1;

    //  cudaDeviceSynchronize();
    // for (int outputIndex = 0; outputIndex < outputSize; outputIndex++)
    //  {
    //  }
};

Channel* NewGpuAllocateChannel(int size)
{
    Channel* channel;

    cudaMalloc((void**)&channel, size * sizeof(Channel));

    return channel;
};