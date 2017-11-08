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
    
    
    // MARK: - Outlets
    @IBOutlet weak var display: UILabel?
    
    
    // MARK: - Action Methods
    @IBAction func touchDigit(_ sender: UIButton) {
        
        let digit = sender.currentTitle!
        
        if userIsInMiddleOfTyping {
            let textCurrentlyInDisplay = display!.text!
            display!.text = textCurrentlyInDisplay + digit
        } else {
            userIsInMiddleOfTyping = true
            display!.text = digit
        }
    }
    
    @IBAction func performCalculation(_ sender: UIButton) {
        userIsInMiddleOfTyping = false
        
        if let mathSymbol = sender.currentTitle {
            switch mathSymbol {
            case "π":
                display!.text = String(Double.pi)
            case "√":
                // create and check operand
                if let operand = Double(display!.text!) {
                    display!.text = String(sqrt(operand))
                }
            default:
                break
            }
        }
    }
}

