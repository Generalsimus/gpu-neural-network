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
 

/* if (chanIndex == 0) {
      printf("START\n ");
      LogInput(forwardInput);
      printf("END\n ");
  }*/
Inputs ForWardAfterIndex(Channel* chan, Inputs* forwardInput, int chanIndex)
{
    if (chanIndex > (chan->layersCount - 2)) {
        printf("Train Error: Channel max size is %d (line %d): %s\n", (chan->layersCount - 1), __LINE__, __FILE__);
    };

    Connects connect = chan->allocatedConnects[chanIndex];
    Inputs outputs = chan->allocatedOutputs[chanIndex];
    /////////////////////////////////////////////////////////////////////////////////////
    

    if (chanIndex == 0) {
        LogInput(forwardInput);
    }

    ForwardSum<<<connect.blocksPerGrid, connect.threadsPerBlock>>>(forwardInput->allocatedInputs, forwardInput->size, outputs.allocatedInputs, outputs.size, connect.widths);

     
    ForwardSigmoid<<<outputs.blocksPerGrid, outputs.threadsPerBlock>>>(outputs.allocatedInputs, connect.biases);
     


    if (chanIndex == (chan->layersCount - 2)) { 
        return outputs;
    }
    else {
        return ForWardAfterIndex(chan, &outputs, (chanIndex + 1));
    }
}

Inputs ForWards(Channel* chan, Inputs* forwardInput)
{
    return ForWardAfterIndex(chan, forwardInput, 0);
};

float* TrainAfterIndex(Channel* chan, Inputs* forwardInput, Inputs* desiredOutputs, float* learnRate, int chanIndex)
{
    if (chanIndex > (chan->layersCount - 2)) {
        printf("Train Error: Channel max size is %d (line %d): %s\n", (chan->layersCount - 1), __LINE__, __FILE__);
    };
    Connects connect = chan->allocatedConnects[chanIndex];
    Inputs outputs = chan->allocatedOutputs[chanIndex];
    /////////////////////////////////////////////////////////////////////////////////////

    ForwardSum<<<connect.blocksPerGrid, connect.threadsPerBlock>>>(forwardInput->allocatedInputs, forwardInput->size, outputs.allocatedInputs, outputs.size, connect.widths);

    ForwardSigmoid<<<outputs.blocksPerGrid, outputs.threadsPerBlock>>>(outputs.allocatedInputs, connect.biases);

    /////////////////////////////////////////////////////////////////////////////////////
    size_t outputsSize = InputSize(&outputs);


    size_t inputsSize = InputSize(forwardInput); 
    /////////////////////////////////////////////////////////////////////////////////////

    //if (chanIndex == 0) {

        //LogInput(forwardInput);
    //}

    if (chanIndex == (chan->layersCount - 2)) {
        float* deltas = AllocateGpuFloatArray(outputsSize); 

        LogError(&outputs, desiredOutputs->allocatedInputs);
        
        TrainError<<<outputs.blocksPerGrid, outputs.threadsPerBlock>>>(outputs.allocatedInputs, desiredOutputs->allocatedInputs, deltas);
        
        ForwardSigmoidDerivative<<<outputs.blocksPerGrid, outputs.threadsPerBlock>>>(outputs.allocatedInputs, deltas);

        float* deltasOutputs = AllocateGpuFloatArray(inputsSize);

        TrainUpdateWidths<<<connect.blocksPerGrid, connect.threadsPerBlock>>>(forwardInput->allocatedInputs, forwardInput->size, outputs.allocatedInputs, outputs.size, connect.widths, connect.biases, deltas, deltasOutputs, learnRate);
        

        cudaFree(deltas);
        return deltasOutputs;
    }
    else {
        float* deltas = TrainAfterIndex(chan, &outputs, desiredOutputs, learnRate, (chanIndex + 1));
        
        ForwardSigmoidDerivative<<<outputs.blocksPerGrid, outputs.threadsPerBlock>>>(outputs.allocatedInputs, deltas);

        float* deltasOutputs = AllocateGpuFloatArray(inputsSize);
        //LogGpuFloatArray<<<forwardInput->blocksPerGrid, forwardInput->threadsPerBlock>>>(connect.widths, forwardInput->size);

        TrainUpdateWidths<<<connect.blocksPerGrid, connect.threadsPerBlock>>>(forwardInput->allocatedInputs, forwardInput->size, outputs.allocatedInputs, outputs.size, connect.widths, connect.biases, deltas, deltasOutputs, learnRate);
        
        //LogGpuFloatArray<<<forwardInput->blocksPerGrid, forwardInput->threadsPerBlock>>>(connect.widths, forwardInput->size);
        cudaFree(deltas);
        return deltasOutputs;
    }

}
void Train(Channel* chan, Inputs* forwardInput, Inputs* desiredOutputs, float learnRate)
{

    float* learnRateGpu;

    cudaMalloc((void**)&learnRateGpu, sizeof(float));

    cudaMemcpy(learnRateGpu, &learnRate, sizeof(int), cudaMemcpyHostToDevice);


    float* deltas = TrainAfterIndex(chan, forwardInput, desiredOutputs, learnRateGpu, 0);

    cudaFree(deltas);
    cudaFree(learnRateGpu);
};

void MakeFillAllocatedOutputs(Channel* chan, float defaultValue)
{
    for (int connectIndex = 0; connectIndex < (chan->layersCount - 1); connectIndex++)
    {
        Inputs outputs = chan->allocatedOutputs[connectIndex];
         
       FillInputsDefaultValue(&outputs, defaultValue);
       
    }
}

void AddOutputInput(Channel* chan, size_t inputSize)
{
    size_t layersCount = chan->layersCount;
   // printf("layersCount: %d \n", layersCount);
     
    if (layersCount > 0) {
        size_t connectsCount = layersCount - 1;


        chan->allocatedConnects = AddElement(chan->allocatedConnects, connectsCount, NewConnection(chan->outputLayerSize, inputSize));

        chan->allocatedOutputs = AddElement(chan->allocatedOutputs, connectsCount, NewInputs(inputSize));

    };


    chan->outputLayerSize = inputSize;
    chan->layersCount = layersCount + 1;
}; 