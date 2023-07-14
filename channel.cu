#include "utils.cu"
#include "connects.cu"
#include "inputs.cu"
#include <cuda_runtime.h>


typedef struct Channel
{
    Inputs* allocatedOutputs;
    Connects* allocatedConnects;
    size_t outputLayerSize;
    size_t layersCount;
} Channel;
 

void ForWards(Channel* chan, Inputs* forwardInput)
{ 
    for (int connectIndex = 0; connectIndex < (chan->layersCount - 1); connectIndex++)
    {
        printf("connectIndex: %d \n", connectIndex);
        Connects connect = chan->allocatedConnects[connectIndex];
        Inputs outputs = chan->allocatedOutputs[connectIndex];

       ForwardSum<<<connect.blocksPerGrid, connect.threadsPerBlock>>>(forwardInput->allocatedInputs, forwardInput->size, outputs.allocatedInputs, outputs.size, connect.widths);
       *forwardInput = outputs;
    }
};
void MakeFillAllocatedOutputs(Channel* chan, float defaultValue)
{
    for (int connectIndex = 0; connectIndex < (chan->layersCount - 1); connectIndex++)
    {
        Inputs outputs = chan->allocatedOutputs[connectIndex];

        printf("III: %d\n", connectIndex);
        FillInputsDefaultValue(&outputs, defaultValue);
    }
}

void AddOutputInput(Channel* chan, size_t inputSize)
{
    size_t layersCount = chan->layersCount;
    printf("layersCount: %d \n", layersCount);
     
    if (layersCount > 0) {
        size_t index = layersCount - 1;




        chan->allocatedConnects = AddElement(chan->allocatedConnects, index, NewConnection(chan->outputLayerSize, inputSize));

        chan->allocatedOutputs = AddElement(chan->allocatedOutputs, index, NewInputs(inputSize));
        

    };


    chan->outputLayerSize = inputSize;
    chan->layersCount = layersCount + 1;
}; 