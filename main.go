package main

// #include <stdio.h>
// #include "./test.h"
import (
	"C"
)

func main() {
	// size := 5
	// Allocate memory for the int array
	// array := (*C.int)(C.malloc(C.size_t(size) * C.sizeof_int))

	// defer C.free(unsafe.Pointer(array)) // Deallocate memory when done
	// fmt.Println([]C.int{-1, 2, 4, 0, 5, 3, 6, 2, 1})

	// arr := []C.int{1, 2, 3, 4, 5}
	// size := C.int(len(arr))

	// C.CreateModel(&arr[0], size)
	// C.CreateModel([]C.int{-1, 2, 4, 0, 5, 3, 6, 2, 1})
	// C.printIntArray([]C.int{-1, 2, 4, 0, 5, 3, 6, 2, 1})
	// // Access and modify the array elements
	// for i := 0; i < size; i++ {
	// 	array[i] = C.int(i + 1)
	// }

	// C.CreateModel(&[]C.int{3, 2, 1})
	C.helloFromC()

	// fff := C.CreateModel([]C.int{3, 2, 1})
	// fmt.Println("a ...any: ", fff)
	// firsName := C.CString("sssa")

	// lastName := C.CString("ss22s")

	// age := C.int(21)
	// msdk2 := C.struct_person_t{
	// 	firstName: firsName,
	// 	lastName:  lastName,
	// 	age:       age,
	// }
	// defer C.free(unsafe.Pointer(firsName))
	// defer C.free(unsafe.Pointer(lastName))
	// // defer C.free(unsafe.Pointer(age))
	// fmt.Println("I am in Go code now!", msdk2, msdk2.person_new(), firsName)
	// C.inC()
}
