//
//  GridView.swift
//  LoveOrLeave
//
//  Created by Rajan Khattri on 8/20/15.
//  Copyright (c) 2015 Rajan Khattri. All rights reserved.
//

import UIKit

class GridView: UIView {

    let kGraphHeight = UIScreen.mainScreen().bounds.size.width
    let kDefaultGraphWidth: CGFloat =  UIScreen.mainScreen().bounds.size.width
    let kOffsetX: CGFloat = -1
    let kStepX: CGFloat = UIScreen.mainScreen().bounds.size.width/3
    let kGraphBottom: CGFloat = UIScreen.mainScreen().bounds.size.width
    let kGraphTop: CGFloat = 0
    let kStepY: CGFloat = UIScreen.mainScreen().bounds.size.width/3
    let kOffsetY: CGFloat = -1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetLineWidth(context, 0.6)
        CGContextSetStrokeColorWithColor(context, UIColor.lightGrayColor().CGColor)
        
        // How many lines?
        let howMany = Int((kDefaultGraphWidth - kOffsetX) / kStepX)
        
        // Here the lines go
        for i in 0..<howMany {
            let index = CGFloat(i)
            CGContextMoveToPoint(context, CGFloat(kOffsetX+index*kStepX), kGraphTop)
            CGContextAddLineToPoint(context, CGFloat(kOffsetX+index*kStepX), kGraphBottom)
        }
        
        let howManyHorizontal = Int((kGraphBottom - kGraphTop - kOffsetY) / kStepY)
        for i in 0..<howManyHorizontal {
            let index = CGFloat(i)
            CGContextMoveToPoint(context, kOffsetX, CGFloat(kGraphBottom-kOffsetY-index*kStepY))
            CGContextAddLineToPoint(context, kDefaultGraphWidth, CGFloat(kGraphBottom-kOffsetY-index*kStepY))
        }
        
        CGContextStrokePath(context)
    }

}
