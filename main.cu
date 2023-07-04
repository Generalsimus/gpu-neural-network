#include <iostream>
#include <stdio.h>
// #include <structs.cu>
#include "channel.cu"

#include <stdio.h>
#include <stdarg.h>

// typedef struct Model
// {
//     Inputs *inputs;
//     Connects *connects;
//     int count;
// } Model;

int main()
{
    float sizes[] = {3, 5, 2};
    Inputs st = {
        sizes,
        3,
    };
    // printf("sizes: %d\n", sizes);

    // Channel chan = {};
    Channel *chan = NewGpuAllocateChannel(1);

    int threadsPerBlock = 1;
    int blocksPerGrid = 1;
    
    AddOutputInput<<<blocksPerGrid, threadsPerBlock>>>(chan, 3);
    AddOutputInput<<<blocksPerGrid, threadsPerBlock>>>(chan, 4);
    AddOutputInput<<<blocksPerGrid, threadsPerBlock>>>(chan, 4);
    // AddOutputInput(chan, 3);


    
    // AddOutputInput<<<blocksPerGrid, threadsPerBlock>>>(chan, 3);
    // AddOutputInput(chan, 3);
    // AddOutputInput(&chan, 3);
    // AddOutputInput(&chan, 4);
    // AddOutputInput(&chan, 4);

    // AddOutputInput(&chan, 4);

    Inputs *res = &st;
    // ForWards(&chan, res);

    // int threadsPerBlock = 1;
    // int blocksPerGrid = 1;
    ForWards<<<blocksPerGrid, threadsPerBlock>>>(chan, res);

    //   int threadsPerBlock = 256; // You can adjust this based on your GPU's capabilities
    // int numBlocks = (arraySize + threadsPerBlock - 1) / threadsPerBlock;
    // searchElementKernel<<<numBlocks, threadsPerBlock>>>(cudaArray, arraySize, targetElement, cudaElementFound);

    // for (int connectIndex = 0; connectIndex < res->count; connectIndex++)
    // {

    //     // float vv = res->allocatedInputs[connectIndex];
    //     // printf("sizes: %d %f\n", connectIndex, vv);
    //     printf("sizes: %d  \n", connectIndex);
    // }
    // return 0;
}