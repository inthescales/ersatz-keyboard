//  Created by Robin Hill on 5/27/22.
//  Copyright © 2022 Apple. All rights reserved.

import UIKit

/// Globe Shape for the change keyboard button
final class GlobeShape: Shape {
    override func drawShape(_ color: UIColor) {
        drawGlobe(self.bounds, color: color)
    }
    
    /// Draw the globe shape
    private func drawGlobe(_ bounds: CGRect, color: UIColor) {
        let factors = getFactors(CGSize(width: 41, height: 40), toRect: bounds)
        let xScale = factors.xScalingFactor
        let yScale = factors.yScalingFactor
        let lineWidthScale = factors.lineWidthScalingFactor
        
        centerShape(CGSize(width: 41 * xScale, height: 40 * yScale), toRect: bounds)
        color.setStroke()
        
        // Draw the oval outline
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 0 * xScale, y: 0 * yScale, width: 40 * xScale, height: 40 * yScale))
        ovalPath.lineWidth = 1 * lineWidthScale
        ovalPath.stroke()
        
        // Vertical center line
        let verticalCenterPath = UIBezierPath()
        verticalCenterPath.move(to: CGPoint(x: 20 * xScale, y: 0 * yScale))
        verticalCenterPath.addLine(to: CGPoint(x: 20 * xScale, y: 40 * yScale))
        verticalCenterPath.lineWidth = 1 * lineWidthScale
        verticalCenterPath.stroke()
        
        // Horizontal center line
        let horizontalCenterPath = UIBezierPath()
        horizontalCenterPath.move(to: CGPoint(x: 0.5 * xScale, y: 19.5 * yScale))
        horizontalCenterPath.addLine(to: CGPoint(x: 39.5 * xScale, y: 19.5 * yScale))
        horizontalCenterPath.lineWidth = 1 * lineWidthScale
        horizontalCenterPath.stroke()
        
        // Right curve
        let rightCurvePath = UIBezierPath()
        rightCurvePath.move(to: CGPoint(x: 21.63 * xScale, y: 0.42 * yScale))
        rightCurvePath.addCurve(to: CGPoint(x: 21.63 * xScale, y: 39.6 * yScale), controlPoint1: CGPoint(x: 21.63 * xScale, y: 0.42 * yScale), controlPoint2: CGPoint(x: 41 * xScale, y: 19 * yScale))
        rightCurvePath.lineCapStyle = .round;
        rightCurvePath.lineWidth = 1 * lineWidthScale
        rightCurvePath.stroke()
        
        // Left curve
        let leftCurvePath = UIBezierPath()
        leftCurvePath.move(to: CGPoint(x: 17.76 * xScale, y: 0.74 * yScale))
        leftCurvePath.addCurve(to: CGPoint(x: 18.72 * xScale, y: 39.6 * yScale), controlPoint1: CGPoint(x: 17.76 * xScale, y: 0.74 * yScale), controlPoint2: CGPoint(x: -2.5 * xScale, y: 19.04 * yScale))
        leftCurvePath.lineCapStyle = .round;
        leftCurvePath.lineWidth = 1 * lineWidthScale
        leftCurvePath.stroke()
        
        // Upper curve
        let upperCurvePath = UIBezierPath()
        upperCurvePath.move(to: CGPoint(x: 6 * xScale, y: 7 * yScale))
        upperCurvePath.addCurve(to: CGPoint(x: 34 * xScale, y: 7 * yScale), controlPoint1: CGPoint(x: 6 * xScale, y: 7 * yScale), controlPoint2: CGPoint(x: 19 * xScale, y: 21 * yScale))
        upperCurvePath.lineCapStyle = .round;
        upperCurvePath.lineWidth = 1 * lineWidthScale
        upperCurvePath.stroke()
        
        // Lower curve
        let lowerCurvePath = UIBezierPath()
        lowerCurvePath.move(to: CGPoint(x: 6 * xScale, y: 33 * yScale))
        lowerCurvePath.addCurve(to: CGPoint(x: 34 * xScale, y: 33 * yScale), controlPoint1: CGPoint(x: 6 * xScale, y: 33 * yScale), controlPoint2: CGPoint(x: 19 * xScale, y: 22 * yScale))
        lowerCurvePath.lineCapStyle = .round;
        lowerCurvePath.lineWidth = 1 * lineWidthScale
        lowerCurvePath.stroke()
        
        endCenter()
    }
}
