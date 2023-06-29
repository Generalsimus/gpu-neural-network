package main

import "fmt"

//#cgo CFLAGS: -I.
//#cgo LDFLAGS: -L. -ltest
//#cgo LDFLAGS: -lcudart
//#include <test.h>
import "C"

func main() {

	// nvcc -m64 -arch=sm_86 -o libtest.so --shared -Xcompiler -fPIC test.cu
	// nvcc -arch=sm_86 -o cuda.so --shared cuda.cu
	//
	// fmt.Printf("Invoking cuda library...\n")
	// fmt.Println("Done ", C.runCudaCode())
	C.runCudaCode()
	fmt.Println("Done ")
}
