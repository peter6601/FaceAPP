//
//  FaceView.swift
//  FaceIt
//
//  Created by 丁暐哲 on 2016/5/21.
//  Copyright © 2016年 Din. All rights reserved.
//

import UIKit

@IBDesignable
class FaceView: UIView {
    
    
    @IBInspectable var scale:CGFloat = 0.9 {didSet {setNeedsDisplay()}}
    @IBInspectable var  mouthCurvature:Double = 1.0 {didSet {setNeedsDisplay()}}

    @IBInspectable var eyeopen:Bool = true {didSet {setNeedsDisplay()}}

    @IBInspectable var eyeBrowTilt:Double = -0.5 {didSet {setNeedsDisplay()}}

    @IBInspectable var color:UIColor = UIColor.blackColor() {didSet {setNeedsDisplay()}}

    @IBInspectable var lineWidth:CGFloat = 5 {didSet {setNeedsDisplay()}}

   private var faceRadius : CGFloat{
          return min(bounds.size.width, bounds.size.height)/2 * scale
        }
    
    
    func changeScale (recognizer:UIPinchGestureRecognizer){
        switch recognizer.state {
        case .Changed, .Ended:
            scale *= recognizer.scale
            recognizer.scale = 1.0
        default:break
        }
    }
    
  private  var  faceCenter : CGPoint{
        return CGPoint(x: bounds.midX, y: bounds.midY)

        }

    
    
   private struct Ratios {
        static let faceRadiusToEyeOffet:CGFloat = 3
        static let faceRadiusToEyeRadius:CGFloat = 5
        static let faceRadiusToMouthWidth:CGFloat = 1
        static let faceRadiusToMouthHeight:CGFloat = 4
        static let faceRadiusToMouthOffset:CGFloat = 3
        static let faceRadiusTobrowOffSet:CGFloat = 4
    }
    
    private enum Eyes {
        case left
        case right
    }
    
    private func pathForCircleAtPoint(midpoint:CGPoint, withRadius:CGFloat)-> UIBezierPath
    {
        
     let pathRoad = UIBezierPath(
        arcCenter: midpoint,
        radius: withRadius,
        startAngle: 0.0,
        endAngle: CGFloat(2*M_PI),
        clockwise: false
        )
        pathRoad.lineWidth = lineWidth
        return pathRoad
    }
    private func goEyesCenter (eye:Eyes) ->CGPoint
    {
        let eyesOffSet = faceRadius/Ratios.faceRadiusToEyeOffet
        var eyesCenter = faceCenter
        
        eyesCenter.y -= eyesOffSet
        switch eye {
        case .left:
            eyesCenter.x -= eyesOffSet
        case .right:
            eyesCenter.x += eyesOffSet
        }
        return eyesCenter
        
    }
    private func pathForEye(eye:Eyes)->UIBezierPath
    {
        
        let eyeRadius = faceRadius / Ratios.faceRadiusToEyeRadius
        let eyesCenter = goEyesCenter(eye)
        if eyeopen {
        return pathForCircleAtPoint(eyesCenter, withRadius: eyeRadius)
         }
        else{
            let path = UIBezierPath()
            path.moveToPoint(CGPoint(x: eyesCenter.x - eyeRadius, y: eyesCenter.y))
            path.addLineToPoint((CGPoint(x: eyesCenter.x + eyeRadius, y: eyesCenter.y)))
            path.lineWidth = lineWidth
            return path
        }
    }

   private func pathForMouth()-> UIBezierPath {
        
        let mouthWidth = faceRadius / Ratios.faceRadiusToMouthWidth
        let mouthHeight = faceRadius / Ratios.faceRadiusToMouthHeight
        let mouthOffSet = faceRadius / Ratios.faceRadiusToMouthOffset
        
        let mouthRect  = CGRect(x: faceCenter.x - mouthWidth/2, y: faceCenter.y + mouthOffSet, width: mouthWidth, height: mouthHeight)
    
    let smileOffSet = CGFloat(max(-1, min(mouthCurvature, 1))) * mouthRect.height
    let startDraw = CGPoint(x: mouthRect.minX, y:mouthRect.minY)
    let endDraw = CGPoint(x: mouthRect.maxX, y: mouthRect.minY)
    let cp1 = CGPoint(x: mouthRect.minX + mouthRect.width/3, y: mouthRect.minY + smileOffSet)
    let cp2 = CGPoint(x: mouthRect.maxX - mouthRect.width/3, y: mouthRect.minY + smileOffSet)
//    return UIBezierPath(rect:mouthRect)
    let path = UIBezierPath()
    path.moveToPoint(startDraw)
    path.addCurveToPoint(endDraw, controlPoint1: cp1, controlPoint2: cp2)
    path.lineWidth = lineWidth
    return path
    
    }
    
    
    
    private func pathForBrow(eye:Eyes)-> UIBezierPath
    {
        var tilt = eyeBrowTilt
        switch eye {
        case  .left: tilt *= -1.0
        case  .right:break
        }
        
        var browCneter =  goEyesCenter(eye)
        browCneter.y -= faceRadius / Ratios.faceRadiusTobrowOffSet
        let eyeRadius = faceRadius / Ratios.faceRadiusToEyeRadius
        
        
        let tiltOffSet = CGFloat(max(-1, min(tilt, 1))) * eyeRadius / 2
        let browStart = CGPoint(x: browCneter.x - eyeRadius, y: browCneter.y - tiltOffSet)
        let browEnd = CGPoint(x: browCneter.x + eyeRadius, y: browCneter.y + tiltOffSet)
        let path = UIBezierPath()
        path.moveToPoint(browStart)
        path.addLineToPoint(browEnd)
        path.lineWidth = lineWidth
        return path
        
    }
    
    override func drawRect(rect: CGRect) {
//        var face = pathForCircleAtPoint(faceCenter, withRadius: faceRadius)
        
        
        color.set()
        pathForCircleAtPoint(faceCenter, withRadius: faceRadius).stroke()
        pathForEye(.left).stroke()
        pathForEye(.right).stroke()
        pathForMouth().stroke()
        pathForBrow(.right).stroke()
        pathForBrow(.left).stroke()
    }


}
