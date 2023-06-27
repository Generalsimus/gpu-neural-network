#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <cuda_runtime.h>
// #include <cuda_runtime.h>
typedef struct Model
{
    int *layersSizes;
    int count;
} Model;

// typedef struct Layer
// {
//     int *layersSizes;
//     int count;
// } Layer;

void CreateWidth(int size)
{
    float *inputs = (float *)malloc(size * sizeof(float));

    float *d_inputs;

    cudaMalloc((void **)&d_inputs, size * sizeof(float));

    cudaMemcpy(d_inputs, inputs, size * sizeof(float), cudaMemcpyHostToDevice);

    printf("inputs: %d\n", inputs);
    printf("d_inputs: %d\n", d_inputs);

    free(inputs);
    cudaFree(d_inputs);
}

void CreateModel(Model model)
{
    int layersCount = model.count;
    int *layersSizes = model.layersSizes;
    int widthCount = 0;
    int prevValue = 0;
    for (int i = 0; i < layersCount; i++)
    {
        int layerInputsSize = layersSizes[i];
        widthCount = widthCount + (layerInputsSize * prevValue);

        printf("Element %d: %d\n", i, layerInputsSize);
        prevValue = layerInputsSize;
    }
    printf("eeee: %d\n", widthCount);
    CreateWidth(widthCount);
    // widths :=
}

// extern "C"
// {
    void helloFromC()
    {
        int sizes[] = {3, 5, 2};
        Model model = {
            sizes,
            sizeof(sizes) / sizeof(sizes[0]),
        };

        CreateModel(model);
        printf("Eleqweqwement: %d\n", model);
    }
// }