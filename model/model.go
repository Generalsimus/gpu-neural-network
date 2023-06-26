// package model

// type Model struct {
// 	learningRate float64
// }

// func (m *Model) Train() {

// }

// type Neuron struct {
// 	TrainChan   func() float64
// 	ForwardChan func() float64
// }

// func (n *Neuron) Connect(p *Neuron) {
// 	nTrainChan := n.TrainChan
// 	pTrainChan := p.TrainChan
// 	nForwardChan := n.ForwardChan
// 	pForwardChan := p.ForwardChan

// 	widget := 0.00
// 	//////////////////////////////////////
// 	n.TrainChan = func() float64 {

// 		return nTrainChan()
// 	}
// 	////////
// 	p.TrainChan = func() float64 {

// 		return pTrainChan()
// 	}
// 	//////////////////////////////////////
// 	n.ForwardChan = func() float64 {

// 		return nForwardChan()
// 	}
// 	////////
// 	p.ForwardChan = func() float64 {

// 		return pForwardChan()
// 	}
// 	//////////////////////////////////////

// }
package model

import "fmt"

// type Net = []struct {
// 	  int | []int
// }

// type Queue []Job

// | []int
// type Net =
// int | []int
// type I interface{ ~int }

//
// var _ I

// type Net interface{ int | []interface{ Net } }
// type Layer struct {
// 	Size int
// }

// type SplitLayer struct {
// 	layers []Layer
// }
// type Net struct {
// 	Layers []Layer || []SplitLayer
// }
type Net interface{}

func CreateNetwork(net []Net) {

	for _, v := range net {

		if layerSize, ok := v.(int); ok {
			fmt.Println("layerSize: ", layerSize)
		} else if splitLayer, ok := v.([]int); ok {
			fmt.Println("splitLayer: ", splitLayer)
		}
	}

	// nete := []interface{}{
	// 	1,
	// 	[]int{2, 3, 4},
	// 	2,
	// }
	// fmt.Println(net)

	// array := []int{1, 2, 3}
	// notArray := "hello"

	// // Append the non-array to the array.
	// array = append(array, notArray)

	// // Print the new array.
	// fmt.Println(array)
}
