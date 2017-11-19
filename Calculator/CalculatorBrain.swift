//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Carlos Poles on 11/11/17.
//  Copyright © 2017 Carlos Poles. All rights reserved.
//

import Foundation


// structs are passed by value. They are copied every time they are created.
// they are different from classes. Classes are passed by reference and live on the heap. Methods of classes
// reference the same "copy" of thclass in the heap.


struct CalculatorBrain {
    
    // the accumulator of the calculator
    private var accumulator: Double? {
        
        willSet {
            if let newAcc = newValue {
                print("accumulator will be set to: \(newAcc)")
            } else {
                print("accumulator is nil.")
            }
        }
        
        didSet {
            if let newAcc = accumulator {
                print("accumulator is now: \(newAcc)")
            } else {
                print("accumulator is nil.")
            }
        }
    }
    
    private enum Operation {
        // use associated values as in the Optional type.
        // Optional is an enum with two cases set and not set
        // set has the associated value called Some
        // not set has the associated value called None
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case random((UInt32) -> UInt32)
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
            "sin" : Operation.unaryOperation(sin),
            "x⁻¹" : Operation.unaryOperation({ 1/$0 }),
            "±" : Operation.unaryOperation({ -$0 }),
            "xⁿ" : Operation.binaryOperation(pow),
            "10ⁿ" : Operation.binaryOperation(pow),
            "×" : Operation.binaryOperation({ $0 * $1 }),
            "+" : Operation.binaryOperation({ $0 + $1 }),
            "−" : Operation.binaryOperation({ $0 - $1 }),
            "÷" : Operation.binaryOperation({ $0 / $1 }),
            "rdm": Operation.random(arc4random_uniform),
            "=" : Operation.equals
    ]
    
    private var pendingBinaryOperation: PendingBinaryOperation? // optional as we are not always on a binary operation
    
    private var resultIsPending: Bool = false // flag to check if there is a binary operation pending
    
    var description: String = String()// it describes the sequence of operations and operands that led to the value returned by result
    
    
    // as this function will change the struct, it must be marked as mutating
    mutating func performOperation(_ symbol: String) {

        // Set accumulator to 10 to perform 10ⁿ operation
        if symbol == "10ⁿ" { accumulator = 10 }
        
        
        if let operation = operations[symbol] {
            
            switch operation {
            // access the associated value of the enum case constant
            case .constant(let value):
                accumulator = value
                if accumulator != nil {
                    if !resultIsPending {
                        description += " "
                    }
                }
            case.unaryOperation(let function):
                if accumulator != nil {
                    
                    var auxDescription: String = ""
                    
                    if description.contains("="){
                        for c: Character in description {
                            
                            if c == "=" {
                                continue
                            } else {
                                auxDescription.append(c)
                            }
                        }
                        print(auxDescription)
                        description = symbol + "(" + auxDescription + ")" + "="
                        
                        
                    } else if description.contains("...") {
                            let range = description.index(description.endIndex, offsetBy: -3)..<description.endIndex
                            
                            description.removeSubrange(range)
                            description += symbol + "(" + String(accumulator!) + ")" + "..."
                        
                    } else {
                        description += symbol + "(" + String(accumulator!) + ")"
                        
                    }
                    
                    accumulator = function(accumulator!)
                    resultIsPending = false
                }
            case.binaryOperation(let function):
                if accumulator != nil {
                    
                    if resultIsPending {
                        // remove the "..." from the description
                        if description.contains("...") {
                            let range = description.index(description.endIndex, offsetBy: -3)..<description.endIndex
                            
                            description.removeSubrange(range)
                            // if the accumulator is equal to π and it is the second operand
                            description += String(accumulator!) + symbol + "..."
                            
                        } else {
                           
                            
                        }
                        
                        // perform the operation
                        performPendingBinaryOperation()
                        // create the new operation having the result (the accumulator)of the first and the firstOperand
                        pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                        
                    } else {
                        // the initial case. Whenever a new operation starts, it sets the pending result to true.
                        
                        // get the current operand and the desired operation
                        pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                        
                        // now the result is pending
                        resultIsPending = true
                        
                        
                        // print Double.pi as π
                        // if the accumulator is equal to π and it is the first operand
                        description += String(accumulator!) + symbol + "..."
                        print(description)
                        
                        // reset the accumulator
                        accumulator = nil
                    }
                }
            case.random(let function):
                
                accumulator = Double(function(10))
                
                if accumulator != nil {
                    if !resultIsPending {
                         description += " "
                    }
                }
             
            case.equals:
                // remove the "..." from the description
                if description.contains("...") {
                    let range = description.index(description.endIndex, offsetBy: -3)..<description.endIndex
                    
                    description.removeSubrange(range)
//                    if accumulator == Double.pi {
//                        description += "π" + "="
//
//                    }
                        // get the accumulator string before it is changed by the operation
                    description += String(accumulator!) + "="
                    
                    print(description)
                } else {
                    description += "="
                }
                performPendingBinaryOperation()
                resultIsPending = false
                
            } //end switch
        }
    }
    
    private mutating func printAccumulatorAsPiSymbol (_ mathSymbol: String) {
        // if the accumulator is equal to π and it is the first operand
        if accumulator == Double.pi {
            description += "π" + mathSymbol + "..."
            print(description)
        } else if mathSymbol == "10ⁿ" {
            description += mathSymbol + "..."
            print(description)
        } else {
            // add ... to the description to demonstrate the waiting for a value
            description += String(accumulator!) + mathSymbol + "..."
            print(description)
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
    mutating func setOperand(_ operand: Double?) {
        // use the nil coalescence operator
        accumulator = operand != nil ? operand! : nil
        
        // if the accumulator is nil (when the clear button is pressed)
        // then end all pending operations are nil
        if accumulator  == nil {
            description = String()
            resultIsPending = false
            pendingBinaryOperation = nil
        }
    }
    
    
    // make the result read-only
    var result: Double? {
        get {
            return accumulator
        }
    }
}
