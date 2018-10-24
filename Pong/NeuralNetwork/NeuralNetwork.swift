//
//  NeuralNetwork.swift
//  NeuralNetwork
//
//  Created by Thomas De Lange on 07-03-18.
//  Copyright © 2018 Thomas De Lange. All rights reserved.
//

import Foundation

 class ActivationFunction{
    
    var function : (Double) -> Double
    var dFunction : (Double) -> Double
    
    init(function :  @escaping (Double) -> Double, dFunction : @escaping (Double) -> Double) {
        self.function = function
        self.dFunction = dFunction
    }
}

let sigmoid = ActivationFunction(function: {1 / (1 + exp(-$0))}, dFunction: {$0 * (1 - $0)})
let tanH = ActivationFunction(function: {Darwin.tanh($0)}, dFunction: {1 - ($0 * $0)})


public class NeuralNetwork
{
    var inputNodes : Int
    var hiddenNodes : Int
    var outputNodes : Int
    
    var weightsInputHidden : Matrix
    var weightsHiddenOutput : Matrix
    
    var hiddenBias : Matrix
    var outputBias : Matrix
    
    var learningRate : Double
    let activationFunction : ActivationFunction
    
    init(input : Int, hidden : Int, output: Int){
        self.inputNodes = input
        self.hiddenNodes = hidden
        self.outputNodes = output
        
        self.weightsInputHidden = Matrix(rows: self.hiddenNodes, cols: self.inputNodes)
        self.weightsHiddenOutput = Matrix(rows: self.outputNodes, cols: self.hiddenNodes)
        
        self.weightsInputHidden.randomize()
        self.weightsHiddenOutput.randomize()

        self.hiddenBias = Matrix(rows: self.hiddenNodes, cols: 1)
        self.outputBias = Matrix(rows: self.outputNodes, cols: 1)
        
        hiddenBias.randomize()
        outputBias.randomize()
        
        self.learningRate = 0.001
        
        self.activationFunction = sigmoid
    }
    
    func guess(inputArray : Array<Double>) -> Array<Double> {
        
        //Put the arrayinput in an vector or single column matrix
        let input = Matrix.fromArray(array: inputArray)
        
        //Compute the result of the hidden layer
        //Input *dot product* weights from hidden nodes + bias
        let hidden = Matrix.dotProduct(a: self.weightsInputHidden, b: input)

        hidden.add(n: self.hiddenBias)

        hidden.map(function: self.activationFunction.function)

        //Compute the result of the output layer
        //Hidden output *dot product* weights from output nodes + bias
        let output = Matrix.dotProduct(a: self.weightsHiddenOutput, b: hidden)
        output.add(n: self.outputBias)
        output.map(function: self.activationFunction.function)

        //Sending the results back
        return output.toArray()
        
    }
    
    func train(inputArray : Array<Double>, targetArray : Array<Double>){
        
        //
        //Start feedforward
        //
        
        //Put the arrayinput in an vector or single column matrix
        let input = Matrix.fromArray(array: inputArray)
        
        //Compute the result of the hidden layer
        //Input *dot product* weights from hidden nodes + bias
        let hidden = Matrix.dotProduct(a: self.weightsInputHidden, b: input)
        hidden.add(n: self.hiddenBias)
        hidden.map(function: self.activationFunction.function)
        
        //Compute the result of the output layer
        //Hidden output *dot product* weights from output nodes + bias
        let output = Matrix.dotProduct(a: self.weightsHiddenOutput, b: hidden)
        output.add(n: self.outputBias)
        output.map(function: self.activationFunction.function)
        
        //
        //Start backproporgation
        //
        
        let target = Matrix.fromArray(array: targetArray)
        
        //Calculate the output error
        let outputError = Matrix.subtract(a: target, b: output)
        
        //Calculate hidden -> output gradient
        let outputGradient = Matrix.map(m : output, function: self.activationFunction.dFunction)
        outputGradient.scale(n: outputError)
        outputGradient.scale(n: self.learningRate)
        
        //Calculate hidden -> output delta
        let hiddenT = Matrix.transpose(m: hidden)
        let weightsHiddenOutputDelta = Matrix.dotProduct(a: outputGradient, b: hiddenT)
        
        //Adjust the output weight
        self.weightsHiddenOutput.add(n: weightsHiddenOutputDelta)
        
        //Adjust the bias weight
        self.outputBias.add(n: outputGradient)
        
        //Calculate the input -> hidden layer error
        let weightsHiddenOutputT = Matrix.transpose(m: self.weightsHiddenOutput)
        let hiddenError = Matrix.dotProduct(a: weightsHiddenOutputT, b: outputError)
        
        //Calculate input -> hidden gradient
        let hiddenGradient = Matrix.map(m: hidden, function: self.activationFunction.dFunction)
        hiddenGradient.scale(n: hiddenError)
        hiddenGradient.scale(n: self.learningRate)
        
        //Calculate hidden deltas
        let inputT = Matrix.transpose(m: input)
        let weightsInputHiddenDelta = Matrix.dotProduct(a: hiddenGradient, b: inputT)
        
        //Adjust the hidden weights
        self.weightsInputHidden.add(n: weightsInputHiddenDelta)
        
        //Adjust the bias weight
        self.hiddenBias.add(n: hiddenGradient)
    }
    
}
