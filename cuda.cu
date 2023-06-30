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

typedef struct Model
{
    float *elements;
    int count;
} Model;

typedef struct Connect
{
     float *widths;
     float *biases;
} Connect;
// typedef struct Connects
// {
//     Connect *Connects;
//     int count;
// } Connects;

Elements AllocateGpuFloatArray(int size)
{
    float *input = (float *)malloc(size * sizeof(float));

    float *d_input;

    cudaMalloc((void **)&d_input, size * sizeof(float));

    cudaMemcpy(d_input, input, size * sizeof(float), cudaMemcpyHostToDevice);

    free(input);
    // sssssssss213
    // cudaFree(d_input);

    Elements widths = {
        d_input,
        size,
    };
    return widths;
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

Elements Forwards(Elements model, Connects LayerConnects, Elements input, Elements output)
{

    for (int connectionIndx = 0; connectionIndx < LayerConnects.count; connectionIndx++)
    {
        int inputSize = model.elements[connectionIndx - 1];
        int outputSize = model.elements[connectionIndx];

        float *currentOutput = (float *)malloc(outputSize * sizeof(float));

        Connect connect = LayerConnects.Connects[connectionIndx];

        Elements currentWidths = connect.widths;
        Elements currentBiases = connect.biases;

        // for (int connectionIndx = 0; connectionIndx < LayerConnects->count; connectionIndx++)
        // {
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

Connects CreateModel(Elements model)
{
    int layersCount = model.count;
    float *inputSizes = model.elements;

    Connect *LayerConnects = (Connect *)malloc(layersCount * sizeof(Connect));
    int prevLayerInputsSize = 0;

    for (int i = 0; i < layersCount; i++)
    {
        int layerInputsSize = inputSizes[i];
        if (i == 0)
        {
            Connect connect = {
                AllocateGpuFloatArray(layerInputsSize * prevLayerInputsSize),
                AllocateGpuFloatArray(layerInputsSize),
            };
            LayerConnects[i] = connect;

            // LayerConnects[i] = CreateWidth(layerInputsSize * prevLayerInputsSize);
        };

        printf("Element %d: %d\n", i, layerInputsSize);
        prevLayerInputsSize = layerInputsSize;
    };

    Connects Connects = {
        LayerConnects,
        layersCount,
    };

    return Connects;
}
int main()
{

    float sizes[] = {3, 5, 2};
    Elements model = {
        sizes,
        sizeof(sizes) / sizeof(sizes[0]),
    };

    Connects Connects = CreateModel(model);

    float inputs[] = {3, 5, 2};
    Elements input = {
        inputs,
        3,
    };
    float outputs[] = {3, 5};
    Elements output = {
        outputs,
        2,

    };
    Forwards(model, Connects, input, output);

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