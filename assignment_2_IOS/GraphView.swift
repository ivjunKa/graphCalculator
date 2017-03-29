//
//  GraphViewController.swift
//  assignment_2_IOS
//
//  Created by Home on 27/03/17.
//  Copyright © 2017 nl.han.ica.mad. All rights reserved.
//

import UIKit
@objc protocol GraphViewDelegate {
    optional func scale(scale: CGFloat, sender: GraphView)
    optional func origin(origin: CGPoint, sender: GraphView)
}
class GraphView: UIView {
    @IBInspectable var axeColor: UIColor = UIColor.blueColor();
    private let drawer = AxesDrawer();
    
    
//    private var graphFrame : CGRect {
//        return convertRect(frame, fromView: superview)
//    }
    
//    let rect = CGRect(x: 0, y: 0, width: 100, height: 100);
//    let size = CGSize(width: 100, height: 100);
//    let point = CGPoint(x: 0, y: 0);
    var pointsPerUnit : CGFloat = 50;
    var delegate : GraphViewDelegate?
    var newAxeOrigin: CGPoint?
    private var axeOrigin : CGPoint {
        get {
            return newAxeOrigin ?? convertPoint(center, fromView: superview) }
        set {
            newAxeOrigin = newValue
            delegate?.origin!(newValue, sender: self)
            setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        drawer.drawAxesInRect(bounds, origin: axeOrigin, pointsPerUnit: pointsPerUnit)
        //here we need to add some kind of looping with points and the add separate method to draw lines between those points
        drawPoint()
    }
    //draws an point at specified location
    func drawPoint(){
        let desiredX: CGFloat = 2
        let desiredY: CGFloat = -2.5
        let xCoord: CGFloat = axeOrigin.x + (pointsPerUnit * desiredX)
        let yCoord: CGFloat = axeOrigin.y - (pointsPerUnit * desiredY)
        let radius: CGFloat = 8
        
        let dotPath = UIBezierPath(ovalInRect: CGRectMake(xCoord, yCoord, radius, radius))
        
        let layer = CAShapeLayer()
        layer.path = dotPath.CGPath
        layer.strokeColor = UIColor.blueColor().CGColor
        
        self.layer.addSublayer(layer)
    }
}
