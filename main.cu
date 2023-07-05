
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include "channel.cu"
#include <stdio.h>

 
 
int main()
{

     Channel *chan = NewGpuAllocateChannel(1);



    printf("{1,2,3,4,5} + {10,20,30,40,50} =  \n");
     
    return 0;
}