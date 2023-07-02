
#include "structs.cu"
#include "utils.cu"
#include "connects.cu"

////////////////////////
typedef struct Channel
{
    Inputs *allocatedOutputs;
    Connects *allocatedConnects;
    int inputsCount;
} Channel;

Inputs ForWards(Channel *chan, Inputs input)
{
    Inputs *inputs = &input;
    for (int connectIndex = 1; connectIndex < (*chan).inputsCount; connectIndex++)
    {
        Connects connect = (*chan).allocatedConnects[connectIndex];
        Inputs outputs = (*chan).allocatedOutputs[connectIndex];

        Forward(connect, *inputs, outputs);
        *inputs = outputs;
    }

    return input;
}

void AddOutputInput(Channel *chan, int inputSize)
{
    int inputsCount = (*chan).inputsCount + 1;
    if (inputsCount > 0)
    {

        ////////////////////////////////////////////////////////
        Inputs *allocatedOutputs = (Inputs *)malloc(inputsCount * sizeof(Inputs));

        for (int outputIndex = 0; outputIndex < (*chan).inputsCount; outputIndex++)
        {
            allocatedOutputs[outputIndex] = (*chan).allocatedOutputs[outputIndex];
        };
        Inputs newInputsElement = {
            AllocateGpuFloatArray(inputSize),
            inputSize,
        };

        allocatedOutputs[inputsCount] = newInputsElement;
        ////////////////////////////////////////////////////////

        Connects *allocatedConnects = (Connects *)malloc(inputsCount * sizeof(Connects));

        int connectsCount = (*chan).inputsCount - 1;
        for (int connectIndex = 0; connectIndex < connectsCount; connectIndex++)
        {
            allocatedConnects[connectIndex] = (*chan).allocatedConnects[connectIndex];
        };
        Inputs lastElement = allocatedOutputs[inputsCount - 1];
        Connects connects = CreateConnection(lastElement.count, inputSize);
        allocatedConnects[inputsCount] = connects;

        ////////////////////////////////////////////////////////
    }

    (*chan).inputsCount = inputsCount;
}