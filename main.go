package main

import (
	// "filer/image"
	"filer/model"
	"fmt"
	// "fmt"
	// "io/fs"
)

func main() {
	// fmt.Println("a ...any")
	// model.Input(0.111)
	// model.NewConnect(5)
	// firsLayer := model.Connect{
	// 	InputSize: 5,
	// }

	inputLayer := model.NewConnect(5, 2)

	fmt.Println("inputLayer: ", inputLayer)
	// model.CreateNetwork(model.Net{
	// 	2,
	// 	23,
	// 	[]int{1, 5},
	// 	2,
	// })
	// image.EachFilesAt("./learn_photos", func(fileName string, _ fs.DirEntry) {
	// 	// fileName := "./" + file.Name()
	// 	fmt.Println("FILE: ", fileName)
	// 	img := image.ReadImage(fileName)

	// 	// image.DecodeImageToInput(img)
	// 	imageInputs := image.DecodeImageToInput(img)

	// 	net := model.CreateModel([]int{
	// 		len(imageInputs),
	// 		100,
	// 		len(imageInputs),
	// 	}, 0.01)

	// 	fmt.Println("net")
	// 	for i := 0; i < 2; i++ {

	// 		fmt.Println("I: ", i)
	// 		net.Train(imageInputs, imageInputs)
	// 	}
	// 	// fmt.Println("Forward: ", net.Forward(imageInputs))
	// 	fmt.Println("Forward: ", net)
	// 	fmt.Println("imageInputs: ", len(imageInputs))
	// })
}
