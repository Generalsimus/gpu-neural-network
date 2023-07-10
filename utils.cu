#include "cuda_runtime.h"
#include <assert.h>
#include <stdio.h>
#include <iostream>



float* AllocateGpuFloatArray(int size)
{
    //  float* input = (float*)malloc(size * sizeof(float));

    float* d_input;

    cudaMalloc((void**)&d_input, size * sizeof(float));

    // cudaMemcpy(d_input, input, size * sizeof(float), cudaMemcpyHostToDevice);

   //  free(input);

    return d_input;
};
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

