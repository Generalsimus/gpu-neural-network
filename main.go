package main

/*
#cgo LDFLAGS: -L. -ltest
int runMeBro();
*/
import "C"
import "fmt"

func main() {

	// nvcc -m64 -arch=sm_86 -o libtest.so --shared -Xcompiler -fPIC test.cu
	// nvcc -arch=sm_86 -o test.so --shared test.cu
	//
	// fmt.Printf("Invoking cuda library...\n")
	// fmt.Println("Done ", C.runCudaCode())
	// C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v12.1\bin
	//set CC=C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v12.1\bin\cl.exe
	// set CC=path\to\cl.exe
	//
	// set CC=cl
	// go env CC

	C.runMeBro()
	fmt.Println("Done")
}
