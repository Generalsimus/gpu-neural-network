package model

import (
	"encoding/json"
	"filer/utils"
	"fmt"
)

type Connect struct {
	InputSize   int
	Widths      [][]float64
	Biases      []float64
	NextConnect *Connect
}

func (l *Connect) String() string {
	data, _ := json.Marshal(l)
	return string(data)
}
func (c *Connect) Forward(input []float64) []float64 {
	output := make([]float64, len(c.Biases))
	for outputIndex, bias := range c.Biases {
		outputNum := 0.00
		for inputIndex, widths := range c.Widths {
			outputNum += widths[outputIndex] * input[inputIndex]
		}
		output[outputIndex] = utils.Sigmoid(outputNum + bias)
	}

	if c.NextConnect == nil {
		return output
	}

	return c.NextConnect.Forward((output))
}
func (c *Connect) AddNewConnect(outputSize int) *Connect {
	c.NextConnect = NewConnect(c.InputSize, outputSize)
	return c.NextConnect
}

func NewConnect(inputSize int, outPutSize int) *Connect {
	widths, biases := CreateWidths(inputSize, outPutSize)

	fmt.Println("widths: ", widths)
	fmt.Println("biases: ", biases)

	return &Connect{
		InputSize: outPutSize,
		Widths:    widths,
		Biases:    biases,
	}
}

func CreateWidths(inputSize int, outPutSize int) ([][]float64, []float64) {
	widths := make([][]float64, inputSize)
	biases := make([]float64, outPutSize)

	for index, _ := range widths {
		inputWidths := make([]float64, outPutSize)
		widths[index] = inputWidths
		for index, _ := range inputWidths {
			inputWidths[index] = 1.00
		}
	}

	for index, _ := range biases {
		biases[index] = 1.00
	}

	return widths, biases
}
