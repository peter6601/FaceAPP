//
//  facialExpression.swift
//  FaceIt
//
//  Created by 丁暐哲 on 2016/5/27.
//  Copyright © 2016年 Din. All rights reserved.
//

import Foundation


struct FacialExpression {
    enum Eyes:Int {
        case Open
        case Closed
        case Squinting
    }
    enum Eyesborw:Int {
        case Relaxd
        case Normal
        case Furrowed
    
    func moreRelaxedBrow() -> Eyesborw{
        return Eyesborw(rawValue: rawValue-1) ?? .Relaxd
    }
    func moreFurrowed() -> Eyesborw{
        return Eyesborw(rawValue: rawValue+1) ?? .Furrowed
    }
}

enum Mouth:Int {
    case Frown
    case Smirk
    case Neutal
    case Grin
    case Smile
    func sadderMouth() -> Mouth{
        return Mouth(rawValue: rawValue-1) ?? .Frown
    }
    func happerMouth() -> Mouth{
        return Mouth(rawValue: rawValue+1) ?? .Smile
    }

}
    var eyes:Eyes
    var eyesBrow: Eyesborw
    var mouth:Mouth
}
