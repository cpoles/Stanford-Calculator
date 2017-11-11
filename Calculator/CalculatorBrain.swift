//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Carlos Poles on 11/11/17.
//  Copyright © 2017 Carlos Poles. All rights reserved.
//

import Foundation

// external functions for math operations

func changeSign(operand: Double) -> Double {
    return -operand
}

func multiply(op1: Double, op2: Double) -> Double {
    return op1 * op2
}


// structs are passed by value. They are copied every time they are created.
// they are different from classes. Classes are passed by reference and live on the heap. Methods of classes
// reference the same "copy" of thclass in the heap.


struct CalculatorBrain {
    
    // the accumulator of the calculator
    private var accumulator: Double?
    
    private enum Operation {
        // use associated values as in the Optional type.
        // Optional is an enum with two cases set and not set
        // set has the associated value called Some
        // not set has the associated value called None
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
    }
    
    // this struct will help to handle the wait for the
    // second operand in a binary operation
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    private var operations: [String : Operation] = [
            "π" : Operation.constant(Double.pi),
            "e" : Operation.constant(M_E),
            "√" : Operation.unaryOperation(sqrt),
            "cos" : Operation.unaryOperation(cos),
            "±" : Operation.unaryOperation(changeSign),
            "×" : Operation.binaryOperation(multiply),
            "=" : Operation.equals
    ]
    
    private var pendingBinaryOperation: PendingBinaryOperation? // optional as we are not always on a binary operation
    
    // as this function will change the struct, it must be marked as mutating
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            
            switch operation {
            // access the associated value of the enum case constant
            case .constant(let value):
                accumulator = value
            case.unaryOperation(let function):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                }
            case.binaryOperation(let function):
                if accumulator != nil {
                    // get the current operand and the desired operation
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    // clear the accumulator to receive the second operand
                    accumulator = nil
                }
            case.equals:
                performPendingBinaryOperation()
            }
        
        }
    }
    
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            // perform the operation with the second operand in the accumulator and update the accumulator
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            // set the operation as nil as it is finished
            pendingBinaryOperation = nil
        }
    }
    
    // as this function will change the struct, it must be marked as mutating
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
    
    // make the result read-only
    var result: Double? {
        get {
            return accumulator
        }
    }
    
    
    
}
