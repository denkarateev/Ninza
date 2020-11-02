//
//  Ext+CGFloat.swift
//  NinjaGo
//
//  Created by Денис Каратеев on 10.10.2020.
//

import CoreGraphics

extension CGFloat {
    static var game1 = GameScene()
    static func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(0xFFFFFFFF)) //return 0, 1
    }
    
    static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        assert(min < max)
        return CGFloat.random() * (max - min) + min //return min or max
    }
    static func random2(max: CGFloat) -> CGFloat {
        return max / game1.moveSpeed 
    }
}
 
