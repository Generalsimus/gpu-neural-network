cmake_minimum_required(VERSION 3.26)
project(cuda_neu CUDA)

set(CMAKE_CUDA_STANDARD 17)

add_executable(cuda_neu main.cu)

set_target_properties(cuda_neu PROPERTIES
        CUDA_SEPARABLE_COMPILATION ON)


#DEFAULT LINKER
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} /NODEFAULTLIB:libcmt.lib")

#GLFW
target_include_directories(cuda_neu PRIVATE "C:/Users/PC/CLionProjects/cuda_neu/glfw/include")

target_link_libraries(cuda_neu C:/Users/PC/CLionProjects/cuda_neu/glfw/lib-vc2022/glfw3.lib)

find_package(OpenGL REQUIRED)

target_link_libraries(cuda_neu OpenGL::GL)

#SKIA
set(SKIA_DIR "C:/skia/out/config")

# Add the Skia source code directory
add_subdirectory(${SKIA_DIR} build)

target_include_directories(cuda_neu PRIVATE "C:/skia/include")

target_link_libraries(cuda_neu skia)