// #include <stdio.h>
// #include <stdlib.h>
// #include <math.h>
// #include <C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v12.1\include\cuda_runtime.h>

// typedef struct Model
// {
//     int *layersSizes;
//     int count;
// } Model;

// void CreateWidth(int size)
// {
//     float *input = (float *)malloc(size * sizeof(float));

//     float *d_input;

//     cudaMalloc((void **)&d_input, size * sizeof(float));

//     cudaMemcpy(d_input, input, size * sizeof(float), cudaMemcpyHostToDevice);

//     free(input);
//     cudaFree(d_input);
// }

// void CreateModel(Model model)
// {
//     int layersCount = model.count;
//     int *layersSizes = model.layersSizes;
//     int widthCount = 0;
//     int prevValue = 0;
//     for (int i = 0; i < layersCount; i++)
//     {
//         int layerInputsSize = layersSizes[i];
//         widthCount = widthCount + (layerInputsSize * prevValue);

//         printf("Element %d: %d\n", i, layerInputsSize);
//         prevValue = layerInputsSize;
//     }
//     printf("eeee: %d\n", widthCount);
//     CreateWidth(widthCount);
//     // widths :=
// }

// // extern "C"
// // {
// void helloFromC()
// {
//     int sizes[] = {3, 5, 2};
//     Model model = {
//         sizes,
//         sizeof(sizes) / sizeof(sizes[0]),
//     };

//     CreateModel(model);
//     printf("Eleqweqwement: %d\n", model);
// }
// // }