#include <iostream>
#include <stdio.h>
// #include <structs.cu>
#include "channel.cu"

#include <stdio.h>
#include <stdarg.h>

// CUDA kernel to add two arrays
// __global__ void addArrays(float *a, float *b, float *c, int size)
// {
//     int tid = blockIdx.x * blockDim.x + threadIdx.x;
//     if (tid < size)
//     {
//         c[tid] = a[tid] + b[tid];
//     }
// }

// typedef struct Inputs
// {
//     float *allocatedInputs;
//     int count;
// } Inputs;

// typedef struct Connects
// {
//     float *widths;
//     float *biases;
// } Connects;

typedef struct Model
{
    Inputs *inputs;
    Connects *connects;
    int count;
} Model;

// typedef struct Channel
// {
//     Inputs *inputs;
//     Connects *connects;
//     int count;
// } Channel;

// typedef struct Connects
// {
//     Connect *Connects;
//     int count;
// } Connects;

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

// void Forward(Connects *LayerConnect, float *inputs, float *allocatedOutput, int inputSize, int outputSize)
// {

//     for (int outputIndex = 0; outputIndex < outputSize; outputIndex++)
//     {
//         float output = 0;

//         for (int inputIndex = 0; inputIndex < inputSize; inputIndex++)
//         {
//             float input = inputs[inputIndex];
//             output += input * (outputIndex * inputSize + inputIndex);
//         };
//         allocatedOutput[outputIndex] = output;
//     };
// }

// void Forwards(Model model, float *input, float *output)
// {

//     // // Inputs *inputs = model.inputs;
//     // Connects *connects = model.connects;

//     // int connectsCount = model.count;
//     // for (int connectionIndex = 0; connectionIndex < connectsCount; connectionIndex++)
//     // {

//     //     Inputs allocatedInput = model.inputs[connectionIndex - 1];
//     //     Inputs allocatedoutput = model.inputs[connectionIndex];

//     //     Connects connect = connects[connectionIndex];

//     //     // float *currentWidths = connect.widths;
//     //     // float *currentBiases = connect.biases;

//     //     for (int outputIndex = 0; outputIndex < allocatedoutput.count; outputIndex++)
//     //     {
//     //         //     float outputForwardValue = 0;
//     //         for (int inputIndex = 0; inputIndex < allocatedInput.count; inputIndex++)
//     //         {
//     //         }

//     //         //     currentOutput[outputIndex] = outputForwardValue;
//     //     }

//     //     // float *currentOutput = (float *)malloc(outputSize * sizeof(float));
//     // }

//     // int layersCount = model.count;
//     // float *inputSizes = model.elements;
//     // int layerStartAt = 0;
//     // int prevInputsSize = 0;
//     // for (int layerIndex = 0; layerIndex < layersCount; layerIndex++)
//     // {
//     //     int inputSize = inputSizes[layerIndex];

//     //     // if (layerIndex != 0)
//     //     // {
//     //     // for (int inputIndex = 0; inputIndex < inputSize; inputSize++)
//     //     // {
//     //     // }
//     //     // }

//     //     printf("Forwards: %d\n", inputSize);
//     //     for (int inputIndex = 0; inputIndex < inputSize; inputSize++)
//     //     {
//     //     }

//     //     layerStartAt = layerStartAt + (inputSize * prevInputsSize);
//     //     prevInputsSize = inputSize;
//     // }
// }
// Elements GetForwardinput(Elements widths, Elements input, int layerStartAt, int inputSize, int OutputSize)
// {

//     float asssss[] = {3, 5, 2};
//     Elements aaa = {
//         asssss,
//         3,
//     };
//     return aaa;
// };

// Model CreateModel(int layersSizes[], int count)
// {
//     Connects *LayerConnects = (Connects *)malloc((count - 1) * sizeof(Connects));
//     Inputs *LayerInputs = (Inputs *)malloc(count * sizeof(Inputs));

//     int prevLayerInputsSize = 0;
//     for (int i = 0; i < count; i++)
//     {
//         int layerInputsSize = layersSizes[i];

//         Inputs inputs = {
//             AllocateGpuFloatArray(layerInputsSize),
//             layerInputsSize,
//         };

//         LayerInputs[i] = inputs;
//         if (i == 0)
//         {

//             LayerConnects[i] = CreateConnection(prevLayerInputsSize, layerInputsSize);
//         };

//         printf("Element %d: %d\n", i, layerInputsSize);
//         prevLayerInputsSize = layerInputsSize;
//     };
//     Model model = {
//         LayerInputs,
//         LayerConnects,
//         count,
//     };
//     return model;
// }

int main()
{
    // int sizes[] = {3, 5, 2};
    // printf("sizes: %d\n", sizes);

    Channel chan = {};

    AddOutputInput(chan, 3);

    printf(  chan);
    // Model model = {
    //     sizes,
    //     sizeof(sizes) / sizeof(sizes[0]),
    // };

    // Model model = CreateModel(sizes, 3);

    // float inputs[] = {3, 5, 2};
    // float outputs[] = {3, 5};

    // Forwards(model, inputs, outputs);

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