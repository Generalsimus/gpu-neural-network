#include "cuda_runtime.h"
#include <assert.h>
#include <stdio.h>
#include <iostream>


float* AllocateGpuFloatArray(size_t size)
{
    //  float* input = (float*)malloc(size * sizeof(float));

    float* d_input;

    cudaMalloc((void**)&d_input, size * sizeof(float));

    // cudaMemcpy(d_input, input, size * sizeof(float), cudaMemcpyHostToDevice);

   //  free(input);

    return d_input;
};


template<typename T>
T* AddElement(T* array, size_t size, T element)
{
    // Create a new array with increased size
    size_t newSize = size + 1;
    T* newArray = (T*)malloc(newSize * sizeof(T));

    // Copy existing elements to the new array
    for (size_t i = 0; i < size; i++)
    {
        newArray[i] = array[i];
    }

    // Append the new element
    newArray[size] = element;

    // Free the memory of the old array
    free(array);

    return newArray;
}
//#define CHECK_CUDA_ERROR(val) check((val), #val, __FILE__, __LINE__)
//template <typename T>
//void check(T err, const char* const func, const char* const file,
//    const int line)
//{
//    if (err != cudaSuccess)
//    {
//        std::cerr << "CUDA Runtime Error at: " << file << ":" << line
//            << std::endl;
//        std::cerr << cudaGetErrorString(err) << " " << func << std::endl;
//        // We don't exit when we encounter CUDA errors in this example.
//        // std::exit(EXIT_FAILURE);
//    }
//}
//template <typename T, typename PropertyType>
//__device__ void setStructProperty(T* myStruct, PropertyType T::* property, PropertyType newValue) {
//    myStruct->*property = newValue;
//}

template<typename F>
__global__ void AllocateArrayInGpuWithDefaultValue(F* inputs, size_t* size, F* defaultNum)
{
    size_t inputIndex = blockIdx.x * blockDim.x + threadIdx.x;

    inputs[inputIndex] = *defaultNum;

    // printf("DDD Float value: %d\n", inputIndex);
     ///printf("Fill Float value: %f\n", inputs[inputIndex]);
     // printf("Fill Float value: %f\n", inputs[inputIndex]);
};
 


size_t FindBalanceThread(size_t num)
{
    int device;
    cudaGetDevice(&device);

    cudaDeviceProp deviceProp;
    cudaGetDeviceProperties(&deviceProp, device);


    for (size_t testNum = deviceProp.maxThreadsPerBlock; testNum != 0; --testNum) {
        if ((num % testNum) == 0) {
            return testNum;
        }
    }

    return 1;
};

#define CUDA_CHECK(call)                                                         \
    do {                                                                         \
        cudaError_t cudaStatus = call;                                           \
        if (cudaStatus != cudaSuccess) {                                         \
            fprintf(stderr, "CUDA Error: %s (line %d): %s\n", cudaGetErrorString(cudaStatus), __LINE__, __FILE__); \
            exit(1);                                                             \
        }                                                                        \
    } while(0)

__global__ void LogGpuFloatArray(float* inputs, size_t* size)
{
    size_t index = blockIdx.x * blockDim.x + threadIdx.x;
    

    if (index == 0) {
        printf("[ %.10f", inputs[index]);
    }
    else {
        printf(", %.10f", inputs[index]);
    }

    if (index == (*size - 1)) {

        printf(" ]\n");
    }
}

