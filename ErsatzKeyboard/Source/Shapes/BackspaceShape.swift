//  Created by Robin Hill on 5/27/22.
//  Copyright © 2022 Apple. All rights reserved.

import UIKit

final class BackspaceShape: Shape {
    override func drawCall(_ color: UIColor) {
        drawBackspace(self.bounds, color: color)
    }

    /// Draws the shape of the backspace key (boxy arrow pointing left, with an X overtop)
    private func drawBackspace(_ bounds: CGRect, color: UIColor) {
        let factors = getFactors(CGSize(width: 44, height: 32), toRect: bounds)
        let xScale = factors.xScalingFactor
        let yScale = factors.yScalingFactor
        let lineWidthScale = factors.lineWidthScalingFactor
        
        centerShape(CGSize(width: 44 * xScale, height: 32 * yScale), toRect: bounds)
        
        // Color to draw the pointed box shape of the backspace symbol
        let shapeColor = color
        
        // Drawing the X in gray simulates a cutout in the shape
        let backgroundColor = UIColor.gray
        
        // Draw pointed backspace polygon
        let polygonPath = UIBezierPath()
        polygonPath.move(to: CGPoint(x: 16 * xScale, y: 32 * yScale))
        polygonPath.addLine(to: CGPoint(x: 38 * xScale, y: 32 * yScale))
        polygonPath.addCurve(to: CGPoint(x: 44 * xScale, y: 26 * yScale), controlPoint1: CGPoint(x: 38 * xScale, y: 32 * yScale), controlPoint2: CGPoint(x: 44 * xScale, y: 32 * yScale))
        polygonPath.addCurve(to: CGPoint(x: 44 * xScale, y: 6 * yScale), controlPoint1: CGPoint(x: 44 * xScale, y: 22 * yScale), controlPoint2: CGPoint(x: 44 * xScale, y: 6 * yScale))
        polygonPath.addCurve(to: CGPoint(x: 36 * xScale, y: 0 * yScale), controlPoint1: CGPoint(x: 44 * xScale, y: 6 * yScale), controlPoint2: CGPoint(x: 44 * xScale, y: 0 * yScale))
        polygonPath.addCurve(to: CGPoint(x: 16 * xScale, y: 0 * yScale), controlPoint1: CGPoint(x: 32 * xScale, y: 0 * yScale), controlPoint2: CGPoint(x: 16 * xScale, y: 0 * yScale))
        polygonPath.addLine(to: CGPoint(x: 0 * xScale, y: 18 * yScale))
        polygonPath.addLine(to: CGPoint(x: 16 * xScale, y: 32 * yScale))
        polygonPath.close()
        shapeColor.setFill()
        polygonPath.fill()
        
        let XLineWidth = 2.5 * lineWidthScale
        
        // Draw first stroke of X
        let XPath1 = UIBezierPath()
        XPath1.move(to: CGPoint(x: 20 * xScale, y: 10 * yScale))
        XPath1.addLine(to: CGPoint(x: 34 * xScale, y: 22 * yScale))
        backgroundColor.setStroke()
        XPath1.lineWidth = XLineWidth
        XPath1.stroke()

        // Draw second stroke of X
        let XPath2 = UIBezierPath()
        XPath2.move(to: CGPoint(x: 20 * xScale, y: 22 * yScale))
        XPath2.addLine(to: CGPoint(x: 34 * xScale, y: 10 * yScale))
        backgroundColor.setStroke()
        XPath2.lineWidth = XLineWidth
        XPath2.stroke()

        endCenter()
    }
}
