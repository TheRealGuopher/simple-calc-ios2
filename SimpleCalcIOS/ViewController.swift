//
//  ViewController.swift
//  SimpleCalcIOS
//
//  Created by JJ Guo on 1/25/18.
//  Copyright © 2018 JJ Guo. All rights reserved.
//

import UIKit

enum Operation:String {
    case Add = "+"
    case Subtract = "-"
    case Multiply = "*"
    case Divide = "/"
    case Mod = "%"
    case NULL = "Null"
    case Avg
    case Count
    case Fact
}

class ViewController: UIViewController {

    @IBOutlet weak var outputLbl: UILabel!
    
    var wordBank:[String] = []
    var runningNumber = ""
    var leftValue = ""
    var rightValue = ""
    var result = ""
    var currentOperation:Operation = .NULL
    var count = 0
    var sum = 0.0
    var countString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        outputLbl.text = "0"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is HistoryViewController {
            let talkView = segue.destination as? HistoryViewController
            talkView?.wordBank = wordBank
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func numberPressed(_ sender: RoundButton) { // everytime number is pressed, this adds to runningNumber
        if runningNumber.count <= 8 {
            runningNumber += "\(sender.tag)"
            outputLbl.text = runningNumber
        }
    }
    @IBAction func allClearPressed(_ sender: RoundButton) {
        runningNumber = ""
        leftValue = ""
        rightValue = ""
        result = ""
        currentOperation = .NULL
        outputLbl.text = "0"
    }
    @IBAction func dotPressed(_ sender: RoundButton) {
        if runningNumber.count <= 7 && !runningNumber.contains("."){
            runningNumber += "."
            outputLbl.text = runningNumber
        }
    }
    @IBAction func equalPressed(_ sender: RoundButton) {
        if currentOperation == .Count || currentOperation == .Avg || currentOperation == .Fact {
            specialOperation(operation: currentOperation)
        } else {
            operation(operation: currentOperation)
        }
    }
    @IBAction func addPressed(_ sender: RoundButton) {
        currentOperation = .Add
        operation(operation: .Add)
    }
    @IBAction func subtractPressed(_ sender: RoundButton) {
        currentOperation = .Subtract
        operation(operation: .Subtract)
    }
    @IBAction func multiplyPressed(_ sender: RoundButton) {
        currentOperation = .Multiply
        operation(operation: .Multiply)
    }
    @IBAction func dividePressed(_ sender: RoundButton) {
        currentOperation = .Divide
        operation(operation: .Divide)
    }
    @IBAction func modPressed(_ sender: RoundButton) {
        currentOperation = .Mod
        operation(operation: .Mod)
    }
    @IBAction func avgPressed(_ sender: RoundButton) {
        currentOperation = .Avg
        operation(operation: currentOperation)
    }
    @IBAction func countPressed(_ sender: RoundButton) {
        currentOperation = .Count
        operation(operation: currentOperation)
    }
    @IBAction func factPressed(_ sender: RoundButton) {
        currentOperation = .Fact
        operation(operation: currentOperation)
    }
    
    // make sure to check if leftValue/rightValue are empty or not empty, all the mutha fucking combos
    // . + 3 doesn't break code
    // Operations with just the dot, only treat it if there's numbers available
    
    func specialOperation(operation: Operation) { // equals pressed
        if operation == .Count {
            if runningNumber == "" {
                result = "\(count)"
            } else {
                result = "\(count + 1)"
            }
            countString += "\(runningNumber) = \(result)"
            wordBank.append(countString)
            countString = ""
            leftValue = result
            runningNumber = ""
            outputLbl.text = result
            count = 0
            currentOperation = .NULL
        } else {
            if runningNumber == "" {
                result = "\(Double(sum) / Double(count))"
                countString += "= \(result)"
                wordBank.append(countString)
                countString = ""
            } else {
                count += 1
                sum += Double(runningNumber)!
                result = "\(Double(sum) / Double(count))"
                countString += "\(runningNumber) = \(result)"
                wordBank.append(countString)
                countString = ""
            }
            leftValue = result
            if (canConvertToInt(num: result)) {
                result = "\(Int(Double(result)!))"
            }
            runningNumber = ""
            outputLbl.text = result
            count = 0
            sum = 0
            currentOperation = .NULL
        }
    }
    
    func operation(operation: Operation) {
        if currentOperation == .Count {
            if runningNumber != "" && runningNumber != "." {
                countString += "\(runningNumber) count "
                leftValue = runningNumber
                runningNumber = ""
                count += 1
            }
        } else if currentOperation == .Fact {
            if runningNumber != "" && runningNumber != "." && Int(Double(runningNumber)!) >= 0 && Double(runningNumber)!.truncatingRemainder(dividingBy: 1) == 0 {
                var prod = 1.0
                var num = Double(runningNumber)!
                while num > 1 {
                    prod *= num
                    num -= 1
                }
                result = String(prod)
                wordBank.append("\(runningNumber)! = \(result)")
                leftValue = result
                runningNumber = ""
                outputLbl.text = result
                currentOperation = .NULL
            } else if leftValue != "" && runningNumber != "." && Int(Double(leftValue)!) >= 0 && Double(leftValue)!.truncatingRemainder(dividingBy: 1) == 0 {
                var prod = 1.0
                var num = Double(leftValue)!
                while num > 1 {
                    prod *= num
                    num -= 1
                }
                result = String(prod)
                wordBank.append("\(runningNumber)! = \(result)")
                leftValue = result
                runningNumber = ""
                outputLbl.text = result
                currentOperation = .NULL
            }
            if (leftValue == "inf" || result == "inf") {
                leftValue = ""
                result = ""
            }
        } else if currentOperation == .Avg {
            if runningNumber != "" && runningNumber != "." {
                sum += Double(runningNumber)!
                countString += "\(runningNumber) avg "
                leftValue = runningNumber
                runningNumber = ""
                count += 1
            } else if leftValue != "" && runningNumber != "." {
                sum += Double(leftValue)!
                countString += "\(leftValue) avg "
                runningNumber = ""
                count += 1
            } else if count > 0 {
                specialOperation(operation: .Avg)
            }
        } else if currentOperation != .NULL {
            if runningNumber != "" && leftValue != "" && runningNumber != "." {
                rightValue = runningNumber
                runningNumber = ""
                var success = true
                var operation = ""
                if currentOperation == .Add {
                    result = "\(Double(leftValue)! + Double(rightValue)!)"
                    operation = "+"
                } else if currentOperation == .Subtract {
                    result = "\(Double(leftValue)! - Double(rightValue)!)"
                    operation = "-"
                } else if currentOperation == .Multiply {
                    result = "\(Double(leftValue)! * Double(rightValue)!)"
                    operation = "*"
                } else if currentOperation == .Divide {
                    result = "\(Double(leftValue)! / Double(rightValue)!)"
                    operation = "/"
                } else if currentOperation == .Mod {
                    if (canConvertToInt(num: leftValue) && canConvertToInt(num: rightValue)) {
                        let times = Int(leftValue)! / Int(rightValue)!
                        result = "\(Int(leftValue)! - (times * Int(rightValue)!))"
                        operation = "%"
                    } else {
                        success = false
                        result = "Can't mod"
                        rightValue = ""
                        currentOperation = .NULL
                    }
                }
                
                if (success && canConvertToInt(num: result) && result.count < 12) {
                    result = "\(Int(Double(result)!))"
//                    wordBank.append("\(leftValue) \(operation) \(rightValue) = \(result)")
                }
                wordBank.append("\(leftValue) \(operation) \(rightValue) = \(result)")
                if (success) {
                    leftValue = result
                }
                outputLbl.text = result
            }
            if runningNumber != "" && leftValue == "" && runningNumber == "." {
                leftValue = ""
                runningNumber = ""
            } else if runningNumber != "" && leftValue == "" {
                leftValue = runningNumber
                runningNumber = ""
            }
            currentOperation = operation
        } else { // "8 +" or "+"
            leftValue = runningNumber
            runningNumber = ""
            currentOperation = operation
        }
    }
    
    func canConvertToInt(num: String) -> Bool {
        return Double(num)!.truncatingRemainder(dividingBy: 1) == 0
    }
    
}

