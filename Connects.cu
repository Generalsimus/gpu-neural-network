

typedef struct Connects
{
    float *widths;
    float *biases;
} Connects;

Connects CreateConnection(int inputSize, int outputSize)
{
    Connects connect = {
        AllocateGpuFloatArray(inputSize * outputSize),
        AllocateGpuFloatArray(outputSize),
    };

    return connect;
};

void Forward(Connects LayerConnect, Inputs input, Inputs output)
{

    int outputSize = output.count;
    int inputSize = input.count;
    // float *widths = LayerConnect.widths;
    float *biases = LayerConnect.biases;

    for (int outputIndex = 0; outputIndex < outputSize; outputIndex++)
    {
        float outputElement = 0;

        for (int inputIndex = 0; inputIndex < inputSize; inputIndex++)
        {
            float inputElement = input.allocatedInputs[inputIndex];
            outputElement += inputElement * (outputIndex * inputSize + inputIndex);
        };
        output.allocatedInputs[outputIndex] = outputElement + biases[outputIndex];
    };
}
