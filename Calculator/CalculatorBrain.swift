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
    private var accumulator: Double?
    
    func performOperation(_ symbol: String) {
        
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
