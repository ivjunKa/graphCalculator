//
//  GraphViewController.swift
//  assignment_2_IOS
//
//  Created by Home on 28/03/17.
//  Copyright © 2017 nl.han.ica.mad. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController, DelegateFromController, GraphViewDelegate {
    private struct Gestures {
        static let PinchAction: Selector = "zoomInAndOut:"
        static let DoubleTapAction: Selector = "changeGraphOrigin:"
        static let PanAction: Selector = "moveGraph:"
    }
    private let brain = CalcBrain()
    var program: AnyObject {
        get {
            return brain.program
        }
        set {
            brain.program = newValue
            print("i`ve received a new value right now!")
            print(brain.program)
            //print(brain.program)
        }
    }
    var titleOfTheGraph : String {
        get {
            return brain.historyStack.historyOperation
        }
        set {
            brain.historyStack.historyOperation = newValue
            print("here is my stack")
            print(brain.historyStack.historyOperation)
            self.title = brain.historyStack.historyOperation
        }
        
    }
    func getFunctionOutputForTheGraph(inputValue:CGFloat, sender: GraphView)->CGFloat?{
        //var outputValue:CGFloat
        print("trying to evaluate now")
        brain.evaluate()
        print("this is what we have in variable values")
        print(brain.variableValues["M"])
        brain.variableValues["M"] = Double(inputValue)
        
        if let outputValue = brain.evaluate(){
            return CGFloat(outputValue)
        }
        return nil
    }
    var operandStack: [String] = [] {
        didSet{
            print("operand stack was set")
            //updateUI()
        }
    }

    @IBOutlet var graphView: GraphView!{
        didSet{
            //graphView.delegate = self
            graphView.dataSource = self
            print("graph view was set succesfully!!!!!!")
            graphView.addGestureRecognizer(UIPinchGestureRecognizer(target: graphView, action: Gestures.PinchAction))
            
            let doubleTapGestureRecognizer = UITapGestureRecognizer(target: graphView, action: Gestures.DoubleTapAction)
            doubleTapGestureRecognizer.numberOfTapsRequired = 2
            graphView.addGestureRecognizer(doubleTapGestureRecognizer)
            
            graphView.addGestureRecognizer(UIPanGestureRecognizer(target: graphView, action: Gestures.PanAction))
            print("before init")
            print(brain.historyStack.historyOperation)
        }
        
    }
//    @IBOutlet weak var graphView: GraphView! {
//        didSet {
//            
//            graphView.delegate = self
//            graphView.dataSource = self
//            print("graph view was set succesfully!!!!!!######")
//        
////            if let scale = userDefaults.objectForKey(Keys.Scale) as? CGFloat {
////                graphView.pointsPerUnits = scale
////            }
////            
////            if let origin = userDefaults.objectForKey(Keys.Origin) as? String {
////                graphView.newAxeOrigin = CGPointFromString(origin)
////            }
////            
////            
////            
////            graphView.addGestureRecognizer(UIPinchGestureRecognizer(target: graphView, action: Gestures.PinchAction))
////            
////            let doubleTapGestureRecognizer = UITapGestureRecognizer(target: graphView, action: Gestures.DoubleTapAction)
////            doubleTapGestureRecognizer.numberOfTapsRequired = 2
////            graphView.addGestureRecognizer(doubleTapGestureRecognizer)
////            
////            graphView.addGestureRecognizer(UIPanGestureRecognizer(target: graphView, action: Gestures.PanAction))
//        }
//    }
    
}