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

        ForwardSigmoid<<<outputs.blocksPerGrid, outputs.threadsPerBlock>>>(outputs.allocatedInputs, connect.biases);

        *forwardInput = outputs;
    }
};

float* TrainAfterIndex(Channel* chan, Inputs* forwardInput, Inputs* desiredOutputs, float learnRate,int chanIndex)
{
    if (chanIndex > (chan->layersCount - 1)) {
        printf("Train Error: Channel max size is %d (line %d): %s\n", (chan->layersCount - 1), __LINE__, __FILE__);
    };
    Connects connect = chan->allocatedConnects[chanIndex];
    Inputs outputs = chan->allocatedOutputs[chanIndex];
    /////////////////////////////////////////////////////////////////////////////////////

    ForwardSum<<<connect.blocksPerGrid, connect.threadsPerBlock>>>(forwardInput->allocatedInputs, forwardInput->size, outputs.allocatedInputs, outputs.size, connect.widths);

    ForwardSigmoid<<<outputs.blocksPerGrid, outputs.threadsPerBlock>>>(outputs.allocatedInputs, connect.biases);

    /////////////////////////////////////////////////////////////////////////////////////
    size_t outputsSize;

    cudaMemcpy(&outputsSize, outputs.size, sizeof(size_t), cudaMemcpyDeviceToHost);

    size_t inputsSize;

    cudaMemcpy(&inputsSize, forwardInput->size, sizeof(size_t), cudaMemcpyDeviceToHost);
    /////////////////////////////////////////////////////////////////////////////////////
   
    if (chanIndex == (chan->layersCount - 2)) {
        float* deltas = AllocateGpuFloatArray(outputsSize);
        TrainError<<<outputs.blocksPerGrid, outputs.threadsPerBlock>>>(outputs.allocatedInputs, desiredOutputs->allocatedInputs, deltas);

        float* deltasOutputs = AllocateGpuFloatArray(inputsSize);


        TrainUpdateWidths<<<connect.blocksPerGrid, connect.threadsPerBlock>>>(forwardInput->allocatedInputs, forwardInput->size, outputs.allocatedInputs, outputs.size, connect.widths, connect.biases, deltas, deltasOutputs);

        return deltasOutputs;
    }
    else { 
        float* deltas = TrainAfterIndex(chan, &outputs, desiredOutputs, learnRate, (chanIndex + 1));

        float* deltasOutputs = AllocateGpuFloatArray(inputsSize);

        TrainUpdateWidths<<<connect.blocksPerGrid, connect.threadsPerBlock>>>(forwardInput->allocatedInputs, forwardInput->size, outputs.allocatedInputs, outputs.size, connect.widths, connect.biases, deltas, deltasOutputs);
        return deltasOutputs;
    }

}
void Train(Channel* chan, Inputs* forwardInput, Inputs* desiredOutputs, float learnRate)
{ 
    float* deltas;
    //inputs[]float64, desiredOutputs[]float64, learnRate float64
    for (int connectIndex = 0; connectIndex < (chan->layersCount - 1); connectIndex++)
    {
        printf("connectIndex: %d \n", connectIndex);
        Connects connect = chan->allocatedConnects[connectIndex];
        Inputs outputs = chan->allocatedOutputs[connectIndex];

       ForwardSum<<<connect.blocksPerGrid, connect.threadsPerBlock>>>(forwardInput->allocatedInputs, forwardInput->size, outputs.allocatedInputs, outputs.size, connect.widths);

       ForwardSigmoid<<<outputs.blocksPerGrid, outputs.threadsPerBlock>>>(outputs.allocatedInputs, connect.biases);
        
       *forwardInput = outputs;
    }

    for (int connectIndex = 0; connectIndex < (chan->layersCount - 1); connectIndex++)
    {
    }

    //if (connectIndex == (chan->layersCount - 2)) {
    //    size_t outputsSize;

    //    cudaMemcpy(&outputsSize, outputs.size, sizeof(size_t), cudaMemcpyDeviceToHost);

    //    float* newDelta;
    //    cudaMalloc((void**)&newDelta, outputsSize * sizeof(float));

    //    //float* outputs, float* desiredOutputs, float* errorAs
    //    TrainError << <outputs.blocksPerGrid, outputs.threadsPerBlock >> > (outputs.allocatedInputs, desiredOutputs.allocatedInputs, newDelta);

    //}
    //else {

    //}
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