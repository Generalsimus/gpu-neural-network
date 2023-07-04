
#include "utils.cu"
#include "connects.cu"

////////////////////////
typedef struct Channel
{
    Inputs *allocatedOutputs;
    Connects *allocatedConnects;
    int outputLayerSize;
    int layersCount;
} Channel;

__global__ void ForWards(Channel *chan, Inputs *forwardInput)
{
    for (int connectIndex = 0; connectIndex < ((*chan).layersCount - 1); connectIndex++)
    {

        Connects connect = (*chan).allocatedConnects[connectIndex];
        Inputs outputs = (*chan).allocatedOutputs[connectIndex];

        Forward(&connect, forwardInput, &outputs);

        ////
        *forwardInput = outputs;
    }
}

__global__ void AddOutputInput(Channel *chan, int inputSize)
{

    // std::cout << "Logger Data: ";
    // std::cout << 12 << " ";
    // for (int i = 0; i < dataSize; ++i) {
    //     std::cout << logData[i] << " ";
    // }
    // std::cout << std::endl;
    printf("lDdsds\n");
    int layersCount = chan->layersCount;
    printf("layersCount: %d \n", layersCount);
    if (layersCount > 0)
    {
        int connectsCount = layersCount - 1;

        ////////////////////////////////////////////////////////
        Inputs *allocatedOutputs = NewGpuAllocateInputs(layersCount);
        // (Inputs *)malloc(layersCount * sizeof(Inputs));

        for (int outputIndex = 0; outputIndex < connectsCount; outputIndex++)
        {
            printf("WW: %d \n", outputIndex);
            allocatedOutputs[outputIndex] = chan->allocatedOutputs[outputIndex];
        };

        Inputs *newInputsElement = NewGpuAllocateSingleInputs(inputSize);
        allocatedOutputs[connectsCount] = *newInputsElement;
        (*chan).allocatedOutputs = allocatedOutputs;

        printf("7885: %d \n", newInputsElement->count);

        ////////////////////////////////////////////////////////

        Connects *allocatedConnects = NewGpuAllocateConnects(layersCount);

        for (int connectIndex = 0; connectIndex < connectsCount; connectIndex++)
        {
            allocatedConnects[connectIndex] = chan->allocatedConnects[connectIndex];
        };

        Connects *connects = CreateConnection((*chan).outputLayerSize, inputSize);
        allocatedConnects[connectsCount] = *connects;

        (*chan).allocatedConnects = allocatedConnects;

        ////////////////////////////////////////////////////////
    }

    (*chan).outputLayerSize = inputSize;
    (*chan).layersCount = layersCount + 1;
}

Channel *NewGpuAllocateChannel(int size)
{
    Channel *devicePtr;
    cudaMalloc(&devicePtr, size * sizeof(float));
    return devicePtr;
}