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
    
    
    // MARK: - Action Methods
    @IBAction func touchDigit(_ sender: UIButton) {
        // the title of button touched
        let digit = sender.currentTitle!
        
        // if the user is typing, append the numbers
        // and display it
        if userIsInMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
            // initial case. once the user enters a number
            // it clears the label and enter the first number
            userIsInMiddleOfTyping = true
            display.text = digit
        }
    }
    
    @IBAction func performCalculation(_ sender: UIButton) {
        
        // user is not typing a number when
        // touches a calculation button
        userIsInMiddleOfTyping = false
        
        // optional binding to check the title
        // of the button with a math symbol
        if let mathSymbol = sender.currentTitle {
            switch mathSymbol {
            case "π":
                displayValue = Double.pi
            case "√":
                displayValue = sqrt(displayValue)
            default:
                break
            }
        }
    }
}

