package image

import (
	"fmt"
	"image"
	"image/jpeg"
	"io/fs"
	"os"
	"path/filepath"
)

func ReadImage(filePath string) image.Image {
	f, err := os.Open(filePath)
	if err != nil {
		panic(err)
	}
	defer f.Close()
	ext1 := filepath.Ext(filePath)
	fmt.Println("ext1:", ext1)
	switch filepath.Ext(filePath) {
	case ".jpeg":
		image, err := jpeg.Decode(f)
		if err != nil {
			panic(err)
		}
		return image
	default:
		panic("UNSUPPORTED IMAGE FILE")
	}
	return nil
}

// func ReadImage(path string) image.Image {
// 	f, err := os.Open(path)
// 	if err != nil {
// 		panic(err)
// 		return nil
// 	}
// 	fi, _ := f.Stat()
// 	fmt.Println(fi.Name())
// 	//defer f.Close()sss
// 	img, format, err := image.Decode(f)
// 	fmt.Println("name", img, format, err)
// 	if err != nil {
// 		panic(err)
// 		return nil
// 	}
// 	// if format != "jpeg" {
// 	// 	fmt.Println("image format is not jpeg")
// 	// 	return nil, errors.New("")
// 	// }
// 	return img
// }

func DecodeImageToInput(image image.Image) []float64 {
	bounds := image.Bounds()
	widget := bounds.Max.X
	height := bounds.Max.Y

	imageInputs := []float64{}
	for row := 0; row <= height; row++ {
		for column := 0; column <= widget; column++ {
			r, g, b, a := image.At(column, row).RGBA()

			imageInputs = append(imageInputs, float64(rgbaToNum(r>>8, g>>8, b>>8, a>>8))/float64(rgbaToNum(255, 255, 255, 255)))
		}
	}

	return imageInputs
}

func EachFilesAt(dir string, callBack func(fileName string, file fs.DirEntry)) {
	entries, err := os.ReadDir(dir)
	if err != nil {
		panic(err)
	}

	for _, file := range entries {
		callBack(dir+"/"+file.Name(), file)
	}

}
func rgbaToNum[T int | uint | uint32](r T, g T, b T, a T) T {
	rgb := r
	rgb = (rgb << 8) + g
	rgb = (rgb << 8) + b
	rgb = (rgb << 8) + a
	return rgb
}

func numToRgba(num int) (int, int, int, int) {

	red := (num >> 24) & 0xFF
	green := (num >> 16) & 0xFF
	blue := (num >> 8) & 0xFF
	a := num & 0xFF

	return red, green, blue, a
}
