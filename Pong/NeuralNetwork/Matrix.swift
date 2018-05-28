//
//  Matrix.swift
//  NeuralNetwork
//
//  Created by Thomas De Lange on 07-03-18.
//  Copyright © 2018 Thomas De Lange. All rights reserved.
//

import Foundation

public class Matrix {
    
    //Variables
    let rows : Int
    let cols : Int
    var grid : [Double]
    
    //Initialization
    init(rows : Int, cols : Int)
    {
        self.rows = rows
        self.cols = cols
        
        grid = Array(repeating: 0.0, count: rows * cols)
        
    }
    
    /*
     Matrix <-> Array functions
     */
    
    //Take an array and make in into a matrix
    static func fromArray(array : Array<Double>) -> Matrix{
        let matrix = Matrix(rows: array.count, cols: 1)
        
        for i in 0..<array.count{
            matrix[i, 0] = array[i]
        }
        return matrix
    }
    
    //Take a matrix and make it into an array
    func toArray() -> Array<Double>{
        var array = Array<Double>()
        for i in 0..<rows {
            for j in 0..<cols{
                array.append(self[i, j])
            }
        }
        return array
    }
    
    /*
     Scalar && element wise funtions
     */
    //Subtract
    static func subtract(a : Matrix, b : Matrix) -> Matrix{
        
        let result : Matrix
            if a.rows == b.rows || a.cols == b.cols{
                result = Matrix(rows: a.rows, cols: a.cols)
                for i in 0..<a.rows {
                    for j in 0..<a.cols{
                        result[i, j] = a[i, j] - b[i, j]
                    }
                }
            }else{
                Swift.print("Add: Rows and collumns must match")
                result = Matrix(rows: 1, cols: 1)
            }
        return result
    }
    //Add
    func add(n : Any) {
        
        if let n = n as? Matrix {
            if self.rows == n.rows || self.cols == n.cols{
                for i in 0..<rows {
                    for j in 0..<cols{
                        self[i, j] += n[i, j]
                    }
                }
            }else{
                Swift.print("Add: Rows and collumns must match")
            }
        }
    }
    
    func scale(n : Any) {
        if let n = n as? Matrix {
            if self.cols == n.cols && self.rows == n.rows {
                for i in 0..<rows {
                    for j in 0..<cols{
                        self[i, j] *= n[i, j]
                    }
                }
            } else {
                Swift.print("Scale: Rows and collumns must match")
            }
        }else if let n = n as? Int{
            
            for i in 0..<rows {
                for j in 0..<cols{
                    self[i, j] *= Double(n)
                }
            }
        }
    }
    
    //Matrix wise funtions
    static func dotProduct(a : Matrix, b : Matrix) -> Matrix{
        
        let result : Matrix
        if a.cols == b.rows {
            
            result = Matrix(rows: a.rows, cols: b.cols)
            for i in 0..<result.rows{
                for j in 0..<result.cols{
                    
                    var sum = 0.0
                    for k in 0..<a.cols{
                        
                        sum += a[i, k] * b[k, j]
                    }
                    result[i, j] = sum
                }
            }
        }else {
            
            Swift.print("Dot product: The colums of a must match the rows of b")
            result = Matrix(rows: 1, cols: 1)
            result.add(n: -1)
        }
        return result
    }
    
    //Map funtions
    func map(function : (_ : Double) -> Double){
        for i in 0..<rows {
            for j in 0..<cols{
                let value = function(self[i,j])
                self[i, j] = value
            }
        }
    }
    
    static func map(m : Matrix, function : (_ : Double) -> Double) -> Matrix{
        let matrix = Matrix(rows: m.rows, cols: m.cols)
        
        for i in 0..<m.rows {
            for j in 0..<m.cols{
                let value = function(m[i,j])
                matrix[i, j] = value
            }
        }
        return matrix
    }
    
    
    //Scalar funtions
    func randomize() {
        for i in 0..<rows {
            for j in 0..<cols{
                self[i, j] = Double.random(min: -1, max: 1)
            }
        }
    }
    
    //Transpose function
    static func transpose(m : Matrix) -> Matrix{
        let result = Matrix(rows: m.cols, cols: m.rows)
        for i in 0..<m.rows {
            for j in 0..<m.cols{
                result[j, i] = m[i, j]
            }
        }
        return result
    }
    
    
    //Check if the asked row + col is available
    func indexIsValid(row: Int, col: Int) -> Bool {
        return row >= 0 && row < rows && col >= 0 && col < cols
    }
    
    //Subscript
    subscript(row: Int, col: Int) -> Double {
        get {
            assert(indexIsValid(row: row, col: col), "Index out of range")
            return grid[(row * cols) + col]
        }
        set {
            assert(indexIsValid(row: row, col: col), "Index out of range")
            grid[(row * cols) + col] = newValue
        }
    }
    
    //Print the matrix grid nicely
    func matrixPrint(){
        Swift.print("Rows: \(self.rows), cols: \(self.cols)", terminator:"")
        for i in 0..<rows{
            Swift.print("")
            for j in 0..<cols{
                Swift.print("[\(self[i, j])]", terminator:" ")
            }
        }
        Swift.print("")
        Swift.print("")

    }
}






