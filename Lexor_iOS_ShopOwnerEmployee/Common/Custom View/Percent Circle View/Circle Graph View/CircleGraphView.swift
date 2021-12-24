//
//  CircleGraphView.swift
//  Swift Ring Graph
//
//  Created by Steven Lipton on 3/10/15.
//  Copyright (c) 2015 MakeAppPie.Com. All rights reserved.
//

import UIKit

class CircleGraphView: UIView {

    // MARK: - Properties
    /// From 0 to 100
    var percent: CGFloat = 0.0 {
        didSet {
            endArc = percent / 100
        }
    }
    var arcWidth: CGFloat = 4.0
    var arcColor: UIColor = .graphGreen
    var arcBackgroundColor: UIColor = .graphGray
    /// In range of 0.0 to 1.0
    private var endArc: CGFloat = 0.0 {
        didSet{
            setNeedsDisplay()
        }
    }

    // MARK: - Life cycle
    override func draw(_ rect: CGRect) {

        //Important constants for circle
        let fullCircle = 2.0 * CGFloat.pi
        let start: CGFloat = 0.75 * fullCircle
        let end: CGFloat = (1.0 - endArc) * fullCircle + start

        //find the centerpoint of the rect
        let centerPoint = CGPoint(x: rect.midX, y: rect.midY)

        //define the radius by the smallest side of the view
        var radius: CGFloat = 0.0
        if rect.width > rect.height {
            radius = (rect.width - arcWidth) / 2.0
        } else {
            radius = (rect.height - arcWidth) / 2.0
        }
        //starting point for all drawing code is getting the context.
        let context = UIGraphicsGetCurrentContext()

        //set line attributes
        context?.setLineWidth(arcWidth * 0.8)
        context?.setLineCap(CGLineCap.round)

        //make the circle background
        context?.setStrokeColor(arcBackgroundColor.cgColor)
        context?.addArc(center: centerPoint,
                        radius: radius,
                        startAngle: 0,
                        endAngle: fullCircle,
                        clockwise: false)
        context?.strokePath()

        //draw the arc
        context?.setStrokeColor(arcColor.cgColor)
        context?.setLineWidth(arcWidth)
        context?.addArc(center: centerPoint,
                        radius: radius,
                        startAngle: start,
                        endAngle: end,
                        clockwise: true)
        context?.strokePath()
    }
}
