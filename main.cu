
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include "channel.cu"
#include <stdio.h>
#include <cmath>

 





//uint3 __device_builtin__ __STORAGE__ threadIdx;
//uint3 __device_builtin__ __STORAGE__ blockIdx;
//dim3 __device_builtin__ __STORAGE__ blockDim;
//dim3 __device_builtin__ __STORAGE__ gridDim;
//int __device_builtin__ __STORAGE__ warpSize;
__global__ void ForwardKernel(float* inputs, int inputSize, float* output, int outputSize, float* widths)
{
    unsigned int widthIndex = (blockDim.x * blockIdx.x) + threadIdx.x;

    unsigned int inputIndex = widthIndex / outputSize;
    unsigned int outputIndex = widthIndex - (inputIndex * outputSize);


    output[outputIndex] += inputs[inputIndex] * widths[widthIndex];

   printf("widthIndex: %d \n", widthIndex);
   // printf("inputSize: %d \n", inputSize);
    //printf("inputIndex: %d, outputIndex: %d\n", inputIndex, outputIndex);
}
__global__ void SigmoidKernel(float* output, float* biases)
{
    unsigned int outputIndex = (blockDim.x * blockIdx.x) + threadIdx.x;



    output[outputIndex] = 1.0f / (1.0f + expf(-(output[outputIndex] + biases[outputIndex])));

    // printf("outputIndex: %d \n", outputIndex);
    //printf("output: %.2f\n", output[outputIndex]);
}
__global__ void JustForwardKernel(float* inputs, int inputSize, float* outputs, int outputSize, float* widths, float* biases)
{


    unsigned int outputIndex = (blockDim.x * blockIdx.x) + threadIdx.x;


    float output = 0;


    for (int inputIndex = 0; inputIndex < inputSize; ++inputIndex) {
        float width = widths[inputIndex + (outputIndex * inputSize)];
        output += width + inputs[inputIndex];
    }



    outputs[outputIndex] = output;
    // printf("outputIndex: %d \n", outputIndex);
    //printf("output: %.2f\n", outputs[outputIndex]);
};

int* CalctThreadsAndBlocks(int num) {
    int device;
    cudaGetDevice(&device);

    cudaDeviceProp deviceProp;
    cudaGetDeviceProperties(&deviceProp, device);
    if (num <= deviceProp.maxThreadsPerBlock) {
        int res[2] = {1,num};
        return res;
    }
    int threads = num % deviceProp.maxThreadsPerBlock;
    int res[2] = { ((num - threads) / deviceProp.maxThreadsPerBlock) + 1,threads};
    return res;
};

__global__ void TestKernel()
{
    unsigned int index = (blockDim.x * blockIdx.x) + threadIdx.x;

    printf("index: %d \n", index);

};

int main()
{
    int miniBatchSize = 111;
    // Set the dimensions of the CUDA grid and blocks
    cudaDeviceProp prop;
    cudaGetDeviceProperties(&prop, 0);  // Assuming device 0
    int maxThreadsXx = prop.maxThreadsDim[0];
    int blockDimX = maxThreadsXx;
    int numBlocksX = (miniBatchSize + blockDimX - 1) / blockDimX;

    printf("blockDimX: %d \n", blockDimX);
    printf("numBlocksX: %d \n", numBlocksX);

    int inputsz = 5;
    int outputsz = 5;


    int* siz = CalctThreadsAndBlocks(inputsz* outputsz);


    int block = siz[0];
    int threads = siz[1];


    TestKernel<<<block, threads>>>();

    printf("block: %d \n", block);
    printf("threads: %d \n", threads);
    return 0;
     const int inputsize = 200000;
     const int outputsize = 30000;


     float* input, *output, *widts, *biases;
     cudaMalloc((void**)&input, inputsize * sizeof(float));
     cudaMalloc((void**)&output, outputsize * sizeof(float));
     cudaMalloc((void**)&widts, inputsize* outputsize * sizeof(float));
     cudaMalloc((void**)&biases, outputsize * sizeof(float));

     ////////////////////////////////////////////////////
     cudaEvent_t start, stop;
     cudaEventCreate(&start);
     cudaEventCreate(&stop);

     // Start recording the execution time
     cudaEventRecord(start);
     ////////////////////////////////////////////////////

     //(inputsize * outputsize)

     //ForwardKernel<<<(2147483647 * 50009001), 1 >> >(input, inputsize, output, outputsize, widts);
     SigmoidKernel<<<1, outputsize>>>(output, biases);
     ////////////////////////////////////////////////////
      // Stop recording the execution time
     cudaEventRecord(stop);
     cudaEventSynchronize(stop);

     // Calculate the elapsed time
     float milliseconds = 0.0f;
     cudaEventElapsedTime(&milliseconds, start, stop);

     // Print the kernel execution time
     std::cout << "Kernel execution time: " << milliseconds << " ms" << std::endl;

     // Destroy CUDA events
     cudaEventDestroy(start);
     cudaEventDestroy(stop);
     //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
     cudaEvent_t start2, stop2;
     cudaEventCreate(&start2);
     cudaEventCreate(&stop2);

     // Start recording the execution time
     cudaEventRecord(start2);
     ////////////////////////////////////////////////////

     JustForwardKernel<<<1, outputsize>>>(input, inputsize, output, outputsize, widts, biases);
     ////////////////////////////////////////////////////
      // Stop recording the execution time
     cudaEventRecord(stop2);
     cudaEventSynchronize(stop2);

     // Calculate the elapsed time
     float milliseconds2 = 0.0f;
     cudaEventElapsedTime(&milliseconds2, start2, stop2);

     // Print the kernel execution time
     std::cout << "Kernel execution time22: " << milliseconds2 << " ms" << std::endl;

     // Destroy CUDA events
     cudaEventDestroy(start2);
     cudaEventDestroy(stop2);

     //////////////////////////////////////////////////// 


      


     int device;
     cudaGetDevice(&device);

     cudaDeviceProp devicePropp;
     cudaGetDeviceProperties(&devicePropp, device);

     // Get the maximum number of threads per block
     int maxThreadsPerBlock = devicePropp.maxThreadsPerBlock;

     // Get the maximum dimensions of the grid
     //dim3 maxGridSize = devicePropp.maxGridSize;


     // Get the maximum dimensions of the grid
     int maxBlocksPerMultiprocessor;
     cudaDeviceGetAttribute(&maxBlocksPerMultiprocessor, cudaDevAttrMaxBlocksPerMultiprocessor, device);

      
    // printf("maxBlocksPerGrid123: %d\n", maxBlocksPerMultiprocessor);

     //myKernel << <maxBlocksPerGrid, maxThreadsPerBlock >> > ();

     int deviceCount;
     cudaGetDeviceCount(&deviceCount);

     if (deviceCount == 0) {
         std::cerr << "No CUDA devices found" << std::endl;
         return 1;
     }

     for (int deviceId = 0; deviceId < deviceCount; ++deviceId) {
         cudaDeviceProp deviceProp;
         cudaGetDeviceProperties(&deviceProp, deviceId);

         std::cout << "Device ID: " << deviceId << std::endl;
         std::cout << "Device Name: " << deviceProp.name << std::endl;
         std::cout << "Max Blocks per SM: " << deviceProp.maxBlocksPerMultiProcessor << std::endl;
         std::cout << "Max Threads per Block: " << deviceProp.maxThreadsPerBlock << std::endl;
         std::cout << "Max Threads per SM: " << deviceProp.maxThreadsPerMultiProcessor << std::endl;
         std::cout << "Max Grid Size (x, y, z): " << deviceProp.maxGridSize[0] << ", " << deviceProp.maxGridSize[1]
             << ", " << deviceProp.maxGridSize[2] << std::endl;
         std::cout << std::endl;
    }
    return 0;
}