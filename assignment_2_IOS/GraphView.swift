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
    class DesiredPoint {
        var xPoint: CGFloat
        var yPoint: CGFloat
        init(xPoint: CGFloat,yPoint: CGFloat) {
            self.xPoint = xPoint
            self.yPoint = yPoint
        }
    }
    
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
        //here we need to add some kind of looping with points and the add separate method to draw lines between those points.
        var desiredPoint1 = DesiredPoint(xPoint: 1, yPoint: 2)
        var desiredPoint2 = DesiredPoint(xPoint: 2, yPoint: -3.5)
        var desiredPoint3 = DesiredPoint(xPoint: 3, yPoint: -1)
        
        var arrWithPoints = [DesiredPoint]()
        arrWithPoints.append(desiredPoint1)
        arrWithPoints.append(desiredPoint2)
        arrWithPoints.append(desiredPoint3)
        for var i in 0...arrWithPoints.count - 1 {
           drawPoint(arrWithPoints[i])
            if(i != arrWithPoints.count - 1){
                drawLinesUpdated(arrWithPoints[i],endPoint: arrWithPoints[i+1])
            }
            
        }
        
        
        
    }
    //draws an point at specified location
    func drawPoint(point: DesiredPoint){
        //let desiredX: CGFloat = 2
        //let desiredY: CGFloat = -2.5
        //print(point.xPoint)
        let xCoord: CGFloat = axeOrigin.x + (pointsPerUnit * point.xPoint)
        let yCoord: CGFloat = axeOrigin.y - (pointsPerUnit * point.yPoint)
        let radius: CGFloat = 8
        
        let dotPath = UIBezierPath(ovalInRect: CGRectMake(xCoord, yCoord, radius, radius))
        
        let layer = CAShapeLayer()
        layer.path = dotPath.CGPath
        layer.strokeColor = UIColor.blueColor().CGColor
        
        self.layer.addSublayer(layer)
    }
    func drawLines(startPoint: DesiredPoint, endPoint: DesiredPoint){
        let aPath = UIBezierPath()
        print("trying to draw a line from :")
        print(startPoint.xPoint)
        aPath.moveToPoint(CGPoint(x:startPoint.xPoint, y:startPoint.yPoint))
        
        aPath.addLineToPoint(CGPoint(x:endPoint.xPoint, y:endPoint.yPoint))
        
        //Keep using the method addLineToPoint until you get to the one where about to close the path
        
        //aPath.closePath()
        
        //If you want to stroke it with a red color
        UIColor.redColor().set()
        aPath.stroke()
        print("DOne:")
    }
    func drawLinesUpdated(startPoint: DesiredPoint, endPoint: DesiredPoint){
        CGContextSaveGState(UIGraphicsGetCurrentContext())
        print("trying to draw a line from :")
        print(startPoint.xPoint)
        print("to :")
        print(endPoint.xPoint)
        var color = UIColor.redColor()
        color.set()
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: axeOrigin.x+(pointsPerUnit*startPoint.xPoint), y: axeOrigin.y - (pointsPerUnit * startPoint.yPoint)))
        path.addLineToPoint(CGPoint(x: axeOrigin.x+(pointsPerUnit*endPoint.xPoint), y: axeOrigin.y - (pointsPerUnit * endPoint.yPoint)))
        path.stroke()
    }
}
