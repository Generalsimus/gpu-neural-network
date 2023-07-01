#include <iostream>
#include <stdio.h>

// CUDA kernel to add two arrays
__global__ void addArrays(float *a, float *b, float *c, int size)
{
    int tid = blockIdx.x * blockDim.x + threadIdx.x;
    if (tid < size)
    {
        c[tid] = a[tid] + b[tid];
    }
}

typedef struct Inputs
{
    float *allocatedInputs;
    int count;
} Inputs;

typedef struct Connect
{
    float *widths;
    float *biases;
} Connect;

typedef struct Model
{
    Inputs *inputs;
    Connect *connects;
    int count;
} Model;

// typedef struct Connects
// {
//     Connect *Connects;
//     int count;
// } Connects;

float *AllocateGpuFloatArray(int size)
{
    float *input = (float *)malloc(size * sizeof(float));

    float *d_input;

    cudaMalloc((void **)&d_input, size * sizeof(float));

    cudaMemcpy(d_input, input, size * sizeof(float), cudaMemcpyHostToDevice);

    free(input);

    return d_input;
}

// float GetWidthIndex(Elements model, int layerIndex, int inputIndex, int outputIndex)
// {

//     int layersCount = model.count;
//     float *inputSizes = model.elements;
//     for (int inputIndex = 0; inputIndex < layersCount; inputIndex++)
//     {
//         int inputSize = inputSizes[inputIndex];

//         printf("GetWidthIndex: %d\n", inputSize);
//     }
//     // Elements model = {
//     //     sizes,
//     //     sizeof(sizes) / sizeof(sizes[0]),
//     // };
//     float retur = 0;
//     return retur;
// }
// float **AllocateModelInputs(Model model)
// {
//     int connectsCount = model.count - 1;
//     float** inputs;
//     cudaMalloc((void**)&inputs, connectsCount * sizeof(float*));
//     for (int connectionIndx = 0; connectionIndx < connectsCount; connectionIndx++)
//     {
// inputs[connectionIndx] =
//     }
// }

float *Forwards(Connect *LayerConnect, float *inputs, float *allocatedOutput, int inputSize, int outputSize)
{

    for (int outputIndex = 0; outputIndex < outputSize; outputIndex++)
    {
        float output = 0;

        for (int inputIndex = 0; inputIndex < inputSize; inputIndex++)
        {
            float input = inputs[inputIndex];
            output += input * (outputIndex * inputSize + inputIndex);
        };
        allocatedOutput[outputIndex] = output;
    }
}

float *Forwards(Model model, Connect *LayerConnects, float *input, float *output)
{

    int connectsCount = model.count - 1;
    for (int connectionIndx = 0; connectionIndx < connectsCount; connectionIndx++)
    {

        int inputSize = model.layersSizes[connectionIndx - 1];
        int outputSize = model.layersSizes[connectionIndx];

        float *currentOutput = (float *)malloc(outputSize * sizeof(float));

        Connect connect = LayerConnects[connectionIndx];

        float *currentWidths = connect.widths;
        float *currentBiases = connect.biases;

        // for (int outputIndex = 0; outputIndex < outputSize; outputIndex++)
        // {
        //     float outputForwardValue = 0;
        //     for (int inputIndex = 0; inputIndex < inputSize; inputIndex++)
        //     {
        //     }

        //     currentOutput[outputIndex] = outputForwardValue;
        // }

        // float *currentOutput = (float *)malloc(outputSize * sizeof(float));
    }

    // int layersCount = model.count;
    // float *inputSizes = model.elements;
    // int layerStartAt = 0;
    // int prevInputsSize = 0;
    // for (int layerIndex = 0; layerIndex < layersCount; layerIndex++)
    // {
    //     int inputSize = inputSizes[layerIndex];

    //     // if (layerIndex != 0)
    //     // {
    //     // for (int inputIndex = 0; inputIndex < inputSize; inputSize++)
    //     // {
    //     // }
    //     // }

    //     printf("Forwards: %d\n", inputSize);
    //     for (int inputIndex = 0; inputIndex < inputSize; inputSize++)
    //     {
    //     }

    //     layerStartAt = layerStartAt + (inputSize * prevInputsSize);
    //     prevInputsSize = inputSize;
    // }
}
// Elements GetForwardinput(Elements widths, Elements input, int layerStartAt, int inputSize, int OutputSize)
// {

//     float asssss[] = {3, 5, 2};
//     Elements aaa = {
//         asssss,
//         3,
//     };
//     return aaa;
// };

Model CreateModel(int layersSizes[], int count)
{
    Connect *LayerConnects = (Connect *)malloc((count - 1) * sizeof(Connect));
    Inputs *LayerInputs = (Inputs *)malloc(count * sizeof(Inputs));

    int prevLayerInputsSize = 0;
    for (int i = 0; i < count; i++)
    {
        int layerInputsSize = layersSizes[i];

        Inputs inputs = {
            AllocateGpuFloatArray(layerInputsSize),
            layerInputsSize,
        };

        LayerInputs[i] = inputs;
        if (i == 0)
        {
            Connect connect = {
                AllocateGpuFloatArray(layerInputsSize * prevLayerInputsSize),
                AllocateGpuFloatArray(layerInputsSize),
            };

            LayerConnects[i] = connect;
        };

        printf("Element %d: %d\n", i, layerInputsSize);
        prevLayerInputsSize = layerInputsSize;
    };
    Model model = {
        LayerInputs,
        LayerConnects,
        count,
    };
    return model;
}
int main()
{

    int sizes[] = {3, 5, 2};
    // Model model = {
    //     sizes,
    //     sizeof(sizes) / sizeof(sizes[0]),
    // };

    Connect *Connects = CreateModel(sizes, 3);

    float inputs[] = {3, 5, 2};
    float outputs[] = {3, 5};

    Forwards(model, Connects, inputs, outputs);

    // printf("Eleqweqwement: %d\n", sizes);
    ////
    // const int arraySize = 10;
    // const int arrayBytes = arraySize * sizeof(float);

    // // Input arrays and output array on the host (CPU)
    // float a[arraySize] = {1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0};
    // float b[arraySize] = {10.0, 9.0, 8.0, 7.0, 6.0, 5.0, 4.0, 3.0, 2.0, 1.0};
    // float c[arraySize] = {0};

    // // Device (GPU) pointers for arrays
    // float *dev_a, *dev_b, *dev_c;

    // // Allocate memory on the GPU
    // cudaMalloc((void**)&dev_a, arrayBytes);
    // cudaMalloc((void**)&dev_b, arrayBytes);
    // cudaMalloc((void**)&dev_c, arrayBytes);

    // // Copy input arrays from host to device
    // cudaMemcpy(dev_a, a, arrayBytes, cudaMemcpyHostToDevice);
    // cudaMemcpy(dev_b, b, arrayBytes, cudaMemcpyHostToDevice);

    // // Launch kernel on the GPU
    // int threadsPerBlock = 256;
    // int blocksPerGrid = (arraySize + threadsPerBlock - 1) / threadsPerBlock;
    // addArrays<<<blocksPerGrid, threadsPerBlock>>>(dev_a, dev_b, dev_c, arraySize);

    // // Copy the result from device to host
    // cudaMemcpy(c, dev_c, arrayBytes, cudaMemcpyDeviceToHost);

    // // Free memory on the GPU
    // cudaFree(dev_a);
    // cudaFree(dev_b);
    // cudaFree(dev_c);

    // // Print the result
    // for (int i = 0; i < arraySize; ++i) {
    //     std::cout << c[i] << " ";
    // }
    // std::cout << std::endl;

    return 0;
}