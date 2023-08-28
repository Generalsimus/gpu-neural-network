#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include "channel.cu"
#include <cmath>
#include <stdio.h>
#include <stdlib.h>
#include "skia.cu"
#include <windows.h>


 

 
//__global__ void ForwardKernel(float* inputs, int inputSize, float* output, int outputSize, float* widths)
//{
//    unsigned int widthIndex = (blockDim.x * blockIdx.x) + threadIdx.x;
//
//    unsigned int inputIndex = widthIndex / outputSize;
//    unsigned int outputIndex = widthIndex - (inputIndex * outputSize);
//
//
//    output[outputIndex] += inputs[inputIndex] * widths[widthIndex];
//
//   printf("widthIndex: %d \n", widthIndex);
//   // printf("inputSize: %d \n", inputSize);
//    //printf("inputIndex: %d, outputIndex: %d\n", inputIndex, outputIndex);
//}
//__global__ void SigmoidKernel(float* output, float* biases)
//{
//    unsigned int outputIndex = (blockDim.x * blockIdx.x) + threadIdx.x;
//
//
//
//    output[outputIndex] = 1.0f / (1.0f + expf(-(output[outputIndex] + biases[outputIndex])));
//
//    // printf("outputIndex: %d \n", outputIndex);
//    //printf("output: %.2f\n", output[outputIndex]);
//}
//__global__ void JustForwardKernel(float* inputs, int inputSize, float* outputs, int outputSize, float* widths, float* biases)
//{
//
//
//    unsigned int outputIndex = (blockDim.x * blockIdx.x) + threadIdx.x;
//
//
//    float output = 0;
//
//
//    for (int inputIndex = 0; inputIndex < inputSize; ++inputIndex) {
//        float width = widths[inputIndex + (outputIndex * inputSize)];
//        output += width + inputs[inputIndex];
//    }
//
//
//
//    outputs[outputIndex] = output;
//    // printf("outputIndex: %d \n", outputIndex);
//    //printf("output: %.2f\n", outputs[outputIndex]);
//};

LRESULT CALLBACK WndProc(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam) {
    switch (msg) {
        case WM_PAINT: {
            PAINTSTRUCT ps;
            HDC hdc = BeginPaint(hwnd, &ps);

            // Create Skia Surface and Canvas
            sk_sp<SkSurface> surface = SkSurface::MakeFromHWND(hwnd);
            SkCanvas* canvas = surface->getCanvas();

            // Draw using Skia functions
            SkPaint paint;
            paint.setColor(SK_ColorBLUE);
            canvas->drawRect(SkRect::MakeLTRB(50, 50, 150, 150), paint);

            // Clean up
            EndPaint(hwnd, &ps);
            return 0;
        }
        case WM_CLOSE:
            DestroyWindow(hwnd);
            return 0;
        case WM_DESTROY:
            PostQuitMessage(0);
            return 0;
        default:
            return DefWindowProc(hwnd, msg, wParam, lParam);
    }
}
 

 
//unsigned

int main()
{

    WNDCLASS wc = {0};
    wc.lpfnWndProc = WndProc;
    wc.hInstance = GetModuleHandle(NULL);
    wc.hbrBackground = (HBRUSH)(COLOR_BACKGROUND);
    wc.lpszClassName = "SkiaWindowClass";
    RegisterClass(&wc);

    // Create window
    HWND hwnd = CreateWindow("SkiaWindowClass", "Skia Window", WS_OVERLAPPEDWINDOW,
                             CW_USEDEFAULT, CW_USEDEFAULT, 800, 600,
                             NULL, NULL, wc.hInstance, NULL);
    if (!hwnd) {
        return -1;
    }

    ShowWindow(hwnd, SW_SHOW);

    MSG msg;
    while (GetMessage(&msg, NULL, 0, 0)) {
        TranslateMessage(&msg);
        DispatchMessage(&msg);
    }

    return msg.wParam;

    SKIA();
    float floatmin = FLT_MIN;

    printf("Minimal float value: %.100f \n", FLT_MAX);
    printf("Size of float variable: %zu bytes\n", sizeof(FLT_MIN));

    Channel chan = {};

    AddOutputInput(&chan, 3);
    AddOutputInput(&chan, 3); 
    //AddOutputInput(&chan, 16);
    AddOutputInput(&chan, 2);


    float inputs[5] = { 1,3,4 };
    float inputs2[5] = { 3,0,5 };
   // Inputs* forwardInputs = FloatToInputs(inputs, 5);


    float* inputsNormalizedDeltas = NormalizeDeltas(inputs, 3);
    float* inputsNormalizedDeltas2 = NormalizeDeltas(inputs2, 3);

    Inputs forwardIn = FloatToInputs(inputsNormalizedDeltas, 3);
    Inputs forwardIn2 = FloatToInputs(inputsNormalizedDeltas2, 3);


      
    LogInput(&forwardIn);
    LogInput(&forwardIn2); 


    ////////////////////////////////////
    float trainDesiredOutputs[3] = {  0 , 1 };
    float trainDesiredOutputs2[3] = { 1 , 0 };

    Inputs trainDesiredOutputsForwardIn = FloatToInputs(trainDesiredOutputs, 2); 

    Inputs trainDesiredOutputsForwardIn2 = FloatToInputs(trainDesiredOutputs2, 2);
    ////////////////////////////////////
    /*for (int i = 0; i < 4; i++) {
         MakeFillAllocatedOutputs(&chan, 0);
         Train(&chan, &forwardIn2, &trainDesiredOutputsForwardIn2, 0.01);
    }

    MakeFillAllocatedOutputs(&chan, 0);
    Inputs forwardResult4 = ForWards(&chan, &forwardIn2);

    LogInput(&forwardResult4);
    LogInput(&trainDesiredOutputsForwardIn2);   
    */

    /*
    MakeFillAllocatedOutputs(&chan, 0);
    Train(&chan, &forwardIn2, &trainDesiredOutputsForwardIn2, 1);
    /////////////////////////////////////////////////////////////////////////
    MakeFillAllocatedOutputs(&chan, 0);
    Inputs forwardResult4 = ForWards(&chan, &forwardIn2);

    LogInput(&forwardResult4);
    LogInput(&trainDesiredOutputsForwardIn2);
    */
    //LogEroor(&forwardResult4, trainDesiredOutputsForwardIn.allocatedInputs);

     for (int i = 0; i < 5000; i++) {

     MakeFillAllocatedOutputs(&chan, 0);
     Train(&chan, &forwardIn, &trainDesiredOutputsForwardIn, 0.1f);
     //////////////////////////////////////////////
     MakeFillAllocatedOutputs(&chan, 0); 
     Train(&chan, &forwardIn2, &trainDesiredOutputsForwardIn2, 0.1f);
     MakeFillAllocatedOutputs(&chan, 0);
    }; 


    //////////////////////////////////////////////
    MakeFillAllocatedOutputs(&chan, 0);
    Inputs forwardResult3 = ForWards(&chan, &forwardIn);
    LogInput(&forwardResult3);
    LogInput(&trainDesiredOutputsForwardIn);


    //////////////// 
    MakeFillAllocatedOutputs(&chan, 0);
    Inputs forwardResult4 = ForWards(&chan, &forwardIn2);
    LogInput(&forwardResult4);
    LogInput(&trainDesiredOutputsForwardIn2); 
    //////////////////////////////////////////////
     
    cudaError_t cudaStatus = cudaGetLastError();

    printf("CUDA ERROR: %d\n", cudaStatus != cudaSuccess);
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "CUDA Error: %s\n", cudaGetErrorString(cudaStatus));
        // Handle or report the error appropriately
    }



    return 0;

}