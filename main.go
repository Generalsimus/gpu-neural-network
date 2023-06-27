package main

/*
#include <stdlib.h>
#include "./test.h"
*/
import "C"
import (
	"fmt"
	"unsafe"
)

func main() {
	firsName := C.CString("sssa")

	lastName := C.CString("ss22s")

	age := C.int(21)
	msdk2 := C.struct_person_t{
		firstName: firsName,
		lastName:  lastName,
		age:       age,
	}
	defer C.free(unsafe.Pointer(firsName))
	defer C.free(unsafe.Pointer(lastName))
	// defer C.free(unsafe.Pointer(age))
	fmt.Println("I am in Go code now!", msdk2, msdk2.person_new(), firsName)
	// C.inC()
}
