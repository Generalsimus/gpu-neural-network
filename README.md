# gpu-neural-network
GPU-neural-network

Cuda



```cmake
cmake_minimum_required(VERSION 3.26)
project(cuda_neu CUDA)

set(CMAKE_CUDA_STANDARD 17)


add_executable(cuda_neu main.cu
        window/utils.cpp
        window/utils.h
        window/window.cpp
        window/window.h
        window/test.cpp
        window/test.h
)

set_target_properties(cuda_neu PROPERTIES
        CUDA_SEPARABLE_COMPILATION ON)
#[[
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} /NODEFAULTLIB:libcmt.lib")]]


#[[
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} /NODEFAULTLIB:libcmt.lib")]]

#[[

SET (CMAKE_CUDA_FLAGS_DEBUG "${CMAKE_CUDA_FLAGS_DEBUG} -Xcompiler=/MTd")
SET (CMAKE_CUDA_FLAGS_RELEASE "${CMAKE_CUDA_FLAGS_RELEASE} -Xcompiler=/MT")
]]



 
#[[
#DEFAULT LINKER
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} /NODEFAULTLIB:libcmt.lib")

#GLFW

find_package(OpenGL REQUIRED)

target_link_libraries(cuda_neu OpenGL::GL)]]

#SKIA
#[[
target_include_directories(cuda_neu PRIVATE "C:/skia")
target_include_directories(cuda_neu PRIVATE "C:/skia/include")]]

add_definitions(-D_ITERATOR_DEBUG_LEVEL=0)


# Set the path to Skia's include directory
#[[
target_include_directories(cuda_neu PRIVATE "C:/skia")
target_include_directories(cuda_neu PRIVATE "C:/skia/out/vs")]]



#GLFW
target_include_directories(cuda_neu PRIVATE "C:/Users/PC/CLionProjects/cuda_neu/glfw/include")

target_link_libraries(cuda_neu C:/Users/PC/CLionProjects/cuda_neu/glfw/lib-vc2022/glfw3.lib)


#SKIA
target_include_directories(cuda_neu PRIVATE "C:/skia")
target_include_directories(cuda_neu PRIVATE "C:/skia/include")


target_link_libraries(cuda_neu "C:/skia/out/vs/skia.lib")



#OpenGL
find_package(OpenGL REQUIRED)

target_link_libraries(cuda_neu OpenGL::GL)


set_property(TARGET cuda_neu PROPERTY
        MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Release>:Release>")

```
 