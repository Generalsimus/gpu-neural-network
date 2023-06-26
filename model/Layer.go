package model

import (
	"encoding/json"
	"filer/utils"
	"fmt"
)

type Layer struct {
	// InputSize   int
	LayerWidths [][]float64
	Biases      []float64
	NextLayer   *Layer

	inputSize int

	forward func(inputs []float64) []float64
	train   func()
}

func (l Layer) String() string {
	data, _ := json.Marshal(l)
	return string(data)
}

func (l *Layer) Fill(inputSize int, outPutSize int) {
	fmt.Println("SIZE: ", inputSize, outPutSize)
	//////////////////////////////
	layerWidths := [][]float64{}
	for i := 0; i < outPutSize; i++ {
		inputWidths := []float64{}
		for i := 0; i < inputSize; i++ {
			inputWidths = append(inputWidths, 0.5)
			// inputWidths = append(inputWidths, rand.Float64())
		}

		layerWidths = append(layerWidths, inputWidths)
	}
	// fmt.Println("layerWidths: ", layerWidths)
	//////////////////////////////
	//////////////////////////////
	biases := make([]float64, outPutSize)
	for i := 0; i < outPutSize; i++ {
		biases[i] = 1
	}
	//////////////////////////////
	l.LayerWidths = layerWidths
	l.Biases = biases
	//////////////////////////////
}

type Connect struct {
	InputSize   int
	Widths      [][]float64
	Biases      []float64
	NextConnect *Connect
}

func (c *Connect) Forward(input []float64) []float64 {
	output := make([]float64, len(c.Biases))
	for outputIndex, bias := range c.Biases {
		outputNum := 0.00
		for inputIndex, widths := range c.Widths {
			outputNum += widths[outputIndex] * input[inputIndex]
		}
		output[outputIndex] = (outputNum + bias)
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

// func (l *Layer) ConnectForward(*Layer) {
// forwardPrev := l.forward
// forward = func(inputs []float64) []float64 {

// }

// }
func (l *Layer) Forward(inputs []float64) []float64 {
	layerWidths := l.LayerWidths

	nextLayerInputs := make([]float64, len(layerWidths))
	for layerWidthsIndex, inputWidths := range layerWidths {
		var newInput float64 = 0
		for index, inputWidth := range inputWidths {
			newInput += inputWidth * inputs[index]
		}
		// nextLayerInputs[layerWidthsIndex] = utils.Sigmoid(newInput)
		nextLayerInputs[layerWidthsIndex] = utils.Sigmoid(newInput + l.Biases[layerWidthsIndex])
	}
	// fmt.Println("FORWARD: ", nextLayerInputs)
	if l.NextLayer == nil {
		return nextLayerInputs
	}

	return l.NextLayer.Forward(nextLayerInputs)
}

func (l *Layer) Train(inputs []float64, desiredOutputs []float64, learnRate float64) []float64 {

	// FORWARD ////////////////////////////////////////////
	layerWidths := l.LayerWidths

	nextLayerInputs := make([]float64, len(layerWidths))
	for layerWidthsIndex, inputWidths := range layerWidths {
		var newInput float64 = 0
		for index, inputWidth := range inputWidths {
			newInput += inputWidth * inputs[index]
		}
		// nextLayerInputs[layerWidthsIndex] = utils.Sigmoid(newInput)
		nextLayerInputs[layerWidthsIndex] = utils.Sigmoid(newInput + l.Biases[layerWidthsIndex])
	}
	// fmt.Println("FORWARD: ", nextLayerInputs)

	// BACK PROPAGATION ///////////////////////////////////
	var nextLayerDeltaOutput []float64
	if l.NextLayer == nil {
		nextLayerDeltaOutput = make([]float64, len(nextLayerInputs))
		// errorCost := 0.00
		for index, desiredOutput := range desiredOutputs {
			nextInput := nextLayerInputs[index]
			// errorCost += (desiredOutput - nextInput)

			nextLayerDeltaOutput[index] = (desiredOutput - nextInput) * utils.Derivative(nextInput)
		}
		// fmt.Println("errorCost: ", errorCost)
	} else {
		nextLayerDeltaOutput = l.NextLayer.Train(nextLayerInputs, desiredOutputs, learnRate)
	}

	///////////////////////////////////////////////////////
	deltaOutput := make([]float64, len(inputs))
	// momentum := 0.00

	for inputIndex, input := range inputs {
		delta := 0.00
		for widthsIndex, widths := range l.LayerWidths {
			nextLayerDelta := nextLayerDeltaOutput[widthsIndex]
			width := widths[inputIndex]

			// error += outputNode.Error * outputNode.Input[node].Weight * (node.Output * (1.0 - node.Output))
			delta += (nextLayerDelta * width)

			// outputNode.Input[node].Weight += m_learningRate * outputNode.Error * node.Output;
			widths[inputIndex] += learnRate * nextLayerDelta * input
			// nextLayerInputs[widthsIndex]

			// neuron.bias.weight += neuron.bias.delta * learningRate;
			// m_learningRate * outputNode.Error * outputNode.Bias.Weight
			// l.Biases[widthsIndex] += nextLayerDelta * learnRate
			l.Biases[widthsIndex] += nextLayerDelta * learnRate
			// l.Biases[widthsIndex] += (nextLayerDelta * l.Biases[widthsIndex]) * learnRate
		}

		deltaOutput[inputIndex] = delta * utils.Derivative(input)
	}

	return deltaOutput
}
