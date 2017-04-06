//
//  ViewController.swift
//  calculator
//
//  Created by Home on 09/02/15.
//  Copyright (c) 2015 nl.han.ica.mad. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var displayHistory: UILabel!
    @IBOutlet weak var historyButtonView: UIView!
    var userTyping: Bool = false
    private struct Calculator {
        static let SegueIdentifier = "Graph Seque"
    }
    var buttonAreaWidth: CGFloat = 0
    var brain = CalcBrain()
    var historyStack: String = ""
    @IBAction func buttonHandler(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if digit == "." && display.text!.rangeOfString(".") != nil{
            print("point already added")
        }
        else {
            if !userTyping {
                if digit == "." {
                    display.text = display.text! + digit
                }
                else{
                    display.text = digit

                }
                userTyping = true
            }
            else {
                print("user is in de middle of typing now")
                display.text = display.text! + digit
                
            }
        }
        
    }
    var displayVal : Double? {
        get {
            let formatter = NSNumberFormatter()
            if let number = formatter.numberFromString(display.text!){
                return number.doubleValue
            }
            else{
                display.text = "ERROR"
                return nil
            }
        }
        set {
            if newValue != nil{
                print(newValue)
                display.text = "\(newValue!)"
                userTyping = false
                if brain.historyStackReady{
                    createHistoryButton(brain.historyStack.textWidth)
                    brain.historyStackReady = false
                }
            }
            else
            {
            display.text = " "
            }
        }
    }
    @IBAction func confirmHandler() {
        userTyping = false
        if let val = displayVal{
            if let result = brain.pushToOpStack(displayVal!){
                displayVal = result
            }
        }
        else {
            print("err")
        }
    }
    
  
    @IBAction func memoryButtonHandler(sender: UIButton) {
        
            if displayVal != nil {
                brain.variableValues["M"] = displayVal
                if let result = brain.evaluate() {
                    displayVal = result
                } else {
                    displayVal = nil
                }
            }
        
        userTyping = false
    }
   
    @IBAction func pushMButton(sender: UIButton) {
        if userTyping {
            confirmHandler()
        }
        if let result = brain.pushToOpStack("M") {
            displayVal = result
            print("bla")
        } else {
            displayVal = nil
        }
    }

    @IBAction func customVar(sender: UIButton) {
        brain.setVar("B",value: 20)
        
        if let result = brain.pushToOpStack("B"){
            displayVal = result
        }
    }
    @IBAction func reset() {
        brain.reset();
        display.text = "0"
        userTyping = false
        for view in historyButtonView.subviews {
            view.removeFromSuperview()
        }
        buttonAreaWidth = 0
    }
    @IBAction func performCalculation(sender: UIButton) {
        
        if userTyping{
            confirmHandler()
        }
        if sender.currentTitle! == ""{
            print("bla")
            if let result = brain.pushToOpStack(sender.currentTitle!){
                displayVal = result
            }
        }
        if let operation = sender.currentTitle{
            if operation == "π"{
                if let result = brain.pushToOpStack(sender.currentTitle!){
                    displayVal = result
                }
            }
            else {
                if let result = brain.performOperation(operation){
                    displayVal = result
                }
            }
        }
    }
    func createHistoryButton(width: Int){
        print("creating button")
        let buttonHistory:UIButton = UIButton()
        //      buttonAreaWidth += CGFloat(countElements(displayHistory.text!))
        if buttonAreaWidth == 0 {
            //          buttonsCreating = true
            buttonHistory.frame = CGRectMake(0, 0, CGFloat(width), 20)
            buttonAreaWidth += CGFloat(width)
        }
        else{
            buttonHistory.frame = CGRectMake(buttonAreaWidth, 0, CGFloat(width), 20)
            buttonAreaWidth += CGFloat(width)
        }
        buttonHistory.backgroundColor = UIColor.greenColor()
        buttonHistory.setTitle(brain.historyStack.historyOperation + brain.historyStack.result, forState: UIControlState.Normal)
        buttonHistory.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        historyButtonView.addSubview(buttonHistory)
       
    }

    func buttonAction(sender: UIButton){
        let startIndex = sender.currentTitle!.rangeOfString("=")?.endIndex
        print(sender.currentTitle![startIndex!])
        let valueToDisplay = sender.currentTitle!.substringFromIndex(startIndex!)
        display.text! = valueToDisplay
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Graph Segue"{
            let nav = segue.destinationViewController as! UINavigationController
            //<assignment_2_IOS.GraphViewController: 0x7feaa1497df0>
            let vc = nav.viewControllers[0] as! GraphViewController
            print("lets segue!")
            print(nav.viewControllers[0].view)
            vc.operandStack = brain.program as? [String] ?? []
            vc.program = brain.program
        }
//        var destination = segue.destinationViewController as? UIViewController
//        
//        if let navCon = destination as? UINavigationController {
//            destination = navCon.visibleViewController
//        }
//        
//        if let gvc = destination as? GraphViewController {
//            if let identifier = segue.identifier {
//                
//                switch identifier {
//                case Calculator.SegueIdentifier:
//                    gvc.operandStack = brain.program as? [String] ?? []
//                    gvc.program = brain.program
//                    //print("sequeeeeed!!!!!!! DONE")
//                    //brain.evaluate()
//                default: break
//                }
//            }
//        }
    
}


