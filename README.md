# gpu-neural-network
GPU-neural-network

Cuda


#### CMakeLists.txt
```cmake
cmake_minimum_required(VERSION 3.26)
project(cuda_neu CUDA)

set(CMAKE_CUDA_STANDARD 17)


add_executable(cuda_neu main.cu)

set_target_properties(cuda_neu PROPERTIES
        CUDA_SEPARABLE_COMPILATION ON)
 

add_definitions(-D_ITERATOR_DEBUG_LEVEL=0)

  
set_property(TARGET cuda_neu PROPERTY
        MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Release>:Release>")

```
 