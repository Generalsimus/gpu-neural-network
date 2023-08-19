#include "cuda_runtime.h"
#include <assert.h>
#include <stdio.h>
#include <iostream>

#define CUDA_CHECK(call)                                                         \
    do {                                                                         \
        cudaError_t cudaStatus = call;                                           \
        if (cudaStatus != cudaSuccess) {                                         \
            fprintf(stderr, "CUDA Error: %s (line %d): %s\n", cudaGetErrorString(cudaStatus), __LINE__, __FILE__); \
            exit(1);                                                             \
        }                                                                        \
    } while(0);



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


template<typename F>
__global__ void AllocateArrayInGpuWithDefaultValue(F *inputs, F *defaultNum)
{
    size_t inputIndex = blockIdx.x * blockDim.x + threadIdx.x;

    inputs[inputIndex] = *defaultNum;
};



template<typename T>
void CudaMemoryFIll(T*allocatedArray, size_t size, T defaultValue)
{
    T* defaultValueDevice;

    cudaMalloc((void**)&defaultValueDevice, sizeof(T));

    cudaMemcpy(defaultValueDevice, &defaultValue, sizeof(T), cudaMemcpyHostToDevice);
    ///////////////////////////////////////////////////////////// 
    size_t thredBalance = FindBalanceThread(size);


    dim3 blocksPerGrid(size / thredBalance);
    dim3 threadsPerBlock(thredBalance);
    /////////////////////////////////////////////////////////////
     
    AllocateArrayInGpuWithDefaultValue<<<blocksPerGrid, threadsPerBlock>>>(allocatedArray, defaultValueDevice);
}


float* AllocateGpuFloatArray(size_t size)
{
    //  float* input = (float*)malloc(size * sizeof(float));

    float* values;
    //printf("EEEE: %d \n",size);

    CUDA_CHECK(cudaMalloc((void**)&values, size * sizeof(float)));
    // cudaMemcpy(d_input, input, size * sizeof(float), cudaMemcpyHostToDevice);
   
    CudaMemoryFIll(values, size, 0.00f);

    return values;
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



__global__ void LogGpuFloatArray(float* inputs, size_t* size)
{
    size_t index = blockIdx.x * blockDim.x + threadIdx.x;


    if (index == 0) {
        printf("\n[ %d: %.10f", index, inputs[index]);
    }
    else {
        printf(", %d: %.10f", index, inputs[index]);
    } 

    if (index == (*size - 1)) {

        printf(" ]\n");
    }
}



float* NormalizeDeltas(float *inputs, size_t size)
{ 
    float maxValue = 0.0f;

    for (size_t i = 1; i < size; i++) {
        if (inputs[i] > maxValue) {
            maxValue = inputs[i];
        }
    }

    float* normalizedDeltas = (float*)malloc(size * sizeof(float));

    for (size_t i = 0; i < size; i++) {
        normalizedDeltas[i] = (inputs[i] / maxValue);
    }
     
    return normalizedDeltas;
}

__global__ void GpuSumFloatArray(float *sumAt, float *inputs)
{
    size_t index = blockIdx.x * blockDim.x + threadIdx.x;

    atomicAdd(sumAt, inputs[index]);
}

float* SumFloatArray(float* inputs, size_t* size)
{
    size_t inputSize;

    CUDA_CHECK(cudaMemcpy(&inputSize, size, sizeof(size_t), cudaMemcpyDeviceToHost));


    size_t thredBalance = FindBalanceThread(inputSize);


    dim3 blocksPerGrid(inputSize / thredBalance);
    dim3 threadsPerBlock(thredBalance);

    float *sumAt;
    //printf("EEEE: %d \n",size);

    CUDA_CHECK(cudaMalloc((void**)&sumAt, sizeof(float)));

    float sumAtHost = 0;

    cudaMemcpy(sumAt, &sumAtHost, sizeof(float), cudaMemcpyHostToDevice);

    GpuSumFloatArray<<<blocksPerGrid, threadsPerBlock>>>(sumAt, inputs);

    return sumAt;
};

__global__ void GpuDisadvantageSameSizeFloatArrayElements(float* outputs, float* desiredOutputs, float* errorAs) {
    size_t outputIndex = blockIdx.x * blockDim.x + threadIdx.x;

  //  printf("outputIndexxxx: %d \n", outputIndex);
    float output = outputs[outputIndex];
    //float outputTanh = tanh(output);
    //sigmoidX* (1 - sigmoidX);
    errorAs[outputIndex] = (desiredOutputs[outputIndex] - output);

   //  printf("EEEE: %.10f-%.10f=%.10f \n", desiredOutputs[outputIndex], output, errorAs[outputIndex]);
   // printf("errorAs[outputIndex]: %.5f : %.5f : %.5f \n", desiredOutputs[outputIndex], output, (desiredOutputs[outputIndex] - output) * (output * (1 - output)));
};

float* DisadvantageSameSizeFloatArrayElements(float* inputs, float* disadvantageInputs, size_t* size)
{

    size_t inputSize;

    cudaMemcpy(&inputSize, size, sizeof(size_t), cudaMemcpyDeviceToHost);


    size_t thredBalance = FindBalanceThread(inputSize);


    dim3 blocksPerGrid(inputSize / thredBalance);
    dim3 threadsPerBlock(thredBalance);


    float* disadvantagedInputs = AllocateGpuFloatArray(inputSize);

    GpuDisadvantageSameSizeFloatArrayElements<<<blocksPerGrid, threadsPerBlock>>>(inputs, disadvantageInputs, disadvantagedInputs);

    return disadvantagedInputs;
}


__global__ void GpuSquareArrayNumbers(float* inputs, float* outputs) {
    size_t outputIndex = blockIdx.x * blockDim.x + threadIdx.x;

    float input = inputs[outputIndex];


    outputs[outputIndex] = input * input; 
};

float* SquareArrayNumbers(float* inputs, size_t* size)
{

    size_t inputSize;

    cudaMemcpy(&inputSize, size, sizeof(size_t), cudaMemcpyDeviceToHost);


    size_t thredBalance = FindBalanceThread(inputSize);


    dim3 blocksPerGrid(inputSize / thredBalance);
    dim3 threadsPerBlock(thredBalance);
     

    float* outputs = AllocateGpuFloatArray(inputSize);
    GpuSquareArrayNumbers<<<blocksPerGrid, threadsPerBlock>>>(inputs, outputs);

    return outputs;
}