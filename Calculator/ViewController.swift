//
//  ViewController.swift
//  Calculator
//
//  Created by Carlos Poles on 8/11/17.
//  Copyright © 2017 Carlos Poles. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK - Properties
    var userIsInMiddleOfTyping = false
    
    // calculator brain
    private var brain = CalculatorBrain()
    
    // computed property
    // converts the text in the display to a Double
    // displays values in the display as a String
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        
        set {
            display.text = String(newValue)
        }
    }
    
    
    // MARK: - Outlets
    @IBOutlet weak var display: UILabel!
    
    @IBOutlet weak var operandSeqDisplay: UILabel!
    
    
    
    // MARK: - Action Methods
    @IBAction func touchDigit(_ sender: UIButton) {
        // the title of button touched
        var digit = sender.currentTitle!
        
        // if the user is typing, append the numbers
        // and display it
        if userIsInMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            
            // Allowing only "legal" floating points. No multiple dots.
            // if it already contains a dot. Ignore it and do not change the display
            if textCurrentlyInDisplay.contains(".") && digit == "." {
                display.text = textCurrentlyInDisplay
            } else {
                // otherwise, append the digit after the dot
                display.text = textCurrentlyInDisplay + digit
            }
            
        } else {
            // initial case. when the user has not typed yet (userIsInMiddleOftyping = false)
            // if the first digit typed is a dot, enter "0." and wait for the next entry
            if digit == "." {
                digit = "0."
                // user now is typing
                userIsInMiddleOfTyping = true
                display.text = digit
            }

                userIsInMiddleOfTyping = true
                display.text = digit
        }
    }
    
    @IBAction func performCalculation(_ sender: UIButton) {
        
        if userIsInMiddleOfTyping {
            brain.setOperand(displayValue)
            operandSeqDisplay.text = brain.description
            userIsInMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
            operandSeqDisplay.text = brain.description
        }
        if let result = brain.result {
            displayValue = result
            operandSeqDisplay.text = brain.description
        }
        
    }
    
    @IBAction func clearDisplay(_ sender: UIButton) {
        
        // user is no longer typing
        userIsInMiddleOfTyping = false
        // set display value to default
        displayValue = 0.0
        operandSeqDisplay.text = "0"
        // set operand
        brain.setOperand(nil)
        
        
        print("clear Button is working")
    }
    
    @IBAction func backSpaceDelete(_ sender: UIButton) {
        
        if userIsInMiddleOfTyping {
            display.text = "0"
            userIsInMiddleOfTyping = false
        }
        
    }
    
    
    
    
}

