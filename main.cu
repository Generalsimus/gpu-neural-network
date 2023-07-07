
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include "channel.cu"
#include <stdio.h>

int main()
{

    Channel chan = {};

    AddOutputInput(&chan, 3);
    AddOutputInput(&chan, 3);
    AddOutputInput(&chan, 3);
    AddOutputInput(&chan, 3);


    Channel* gpuChan;

    cudaMalloc(&gpuChan, sizeof(Channel));
    cudaMemcpy(gpuChan, &chan, sizeof(Channel), cudaMemcpyHostToDevice);



    printf("{1,2,3,4,5} + {10,20,30,40,50} =  \n");


    int threadsPerBlock = 1;
    int blocksPerGrid = 1;

    float sizes[] = { 3, 5, 2 };
    Inputs inputs = {
     sizes,
     3,
   };

    Inputs* forwardOutput = &inputs;
    
    ForWards<<<blocksPerGrid, threadsPerBlock>>>(&chan, forwardOutput);



     cudaDeviceSynchronize();

    // Check for errors
     cudaError_t error = cudaGetLastError();
    if (error != cudaSuccess) {
        printf("CUDA error: %s\n", cudaGetErrorString(error));
     }
    //Channel* chan = NewGpuAllocateChannel(1);

    //int threadsPerBlock = 1;
    //int blocksPerGrid = 1;
    // 

    //AddOutputInput<<<blocksPerGrid, threadsPerBlock>>>(chan, 3);
    //AddOutputInput<<<blocksPerGrid, threadsPerBlock>>>(chan, 3);
    //AddOutputInput<<<blocksPerGrid, threadsPerBlock>>>(chan, 3);
    //AddOutputInput<<<blocksPerGrid, threadsPerBlock>>>(chan, 3);


    //printf("{1,2,3,4,5} + {10,20,30,40,50} =  \n");

   // float sizes[] = { 3, 5, 2 };
   // Inputs inputs = {
  //      sizes,
  //      3,
  //  };

  //  Inputs* gpuRes;

  //  cudaMalloc(&gpuRes, sizeof(Inputs));
  //  cudaMemcpy(gpuRes, &inputs, sizeof(Inputs), cudaMemcpyHostToDevice);

   // ForWards<<<blocksPerGrid, threadsPerBlock>>> (chan, gpuRes);

  //  Inputs* cpuOut;
    // cudaMalloc(&cpuOut, sizeof(Inputs));

 //   cudaMemcpy(&cpuOut, gpuRes, sizeof(Inputs), cudaMemcpyDeviceToHost);

  //  printf("{1,2,3,4,5} + {10,20,30,40,50} = %d \n", cpuOut->count);
//    for (int outputIndex = 0; outputIndex < cpuOut->count; outputIndex++)
//    {
//        printf("Element %d: %.2f\n", outputIndex, cpuOut->allocatedInputs[outputIndex]);
//    }
     
    return 0;
}