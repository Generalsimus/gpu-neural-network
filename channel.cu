
#include "structs.cu"
#include "utils.cu"
#include "Connects.cu"

typedef struct Channel
{
    Inputs *allocatedOutputs;
    Connects *allocatedConnects;
    int count;
} Channel;

Inputs ForWards(Channel chan, Inputs input)
{
    Inputs *inputs = &input;
    for (int connectIndex = 1; connectIndex < chan.count; connectIndex++)
    {
        Connects connect = chan.allocatedConnects[connectIndex];
        Inputs outputs = chan.allocatedOutputs[connectIndex];

        Forward(connect, *inputs, outputs);
        *inputs = outputs;
    }

    return input;
}
void AddOutputInput(Channel chan, int inputSize)
{
    // Inputs *allocatedOutputs;
    int count = (chan.count + 1);
    if (count > 1)
    {
        Inputs *allocatedOutputs = (Inputs *)malloc(count * sizeof(Inputs));

        for (int outputIndex = 0; outputIndex < chan.count; outputIndex++)
        {
            allocatedOutputs[outputIndex] = chan.allocatedOutputs[outputIndex];
        };

        Inputs newInputsElement = {
            AllocateGpuFloatArray(inputSize),
            inputSize,
        };

        allocatedOutputs[count] = newInputsElement;

        chan.allocatedOutputs = allocatedOutputs;

        Connects *allocatedConnects = (Connects *)malloc(count * sizeof(Connects));

        int connectsCount = chan.count - 1;
        for (int connectIndex = 0; connectIndex < connectsCount; connectIndex++)
        {
            allocatedConnects[connectIndex] = chan.allocatedConnects[connectIndex];
        };

        Inputs lastElement = allocatedOutputs[count - 1];
        Connects connects = CreateConnection(lastElement.count, inputSize);
        allocatedConnects[count] = connects;

        chan.allocatedConnects = allocatedConnects;
    };

    chan.count = count;
}