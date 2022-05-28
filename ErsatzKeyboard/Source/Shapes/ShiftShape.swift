//  Created by Robin Hill on 5/27/22.
//  Copyright © 2022 Apple. All rights reserved.

import UIKit

/// Shape for drawing the shift key
final class ShiftShape: Shape {
    /// Whether shift lock should be drawn as active
    var withLock: Bool = false {
        didSet {
            self.overflowCanvas.setNeedsDisplay()
        }
    }
    
    override func drawCall(_ color: UIColor) {
        drawShift(self.bounds, color: color, drawUnderline: self.withLock)
    }
    
    /// Draw the shift icon – an upward arrow
    private func drawShift(_ bounds: CGRect, color: UIColor, drawUnderline: Bool) {
        let shapeWidth: CGFloat = 38
        let shapeHeight: CGFloat = drawUnderline ? 38 : 32

        let factors = getFactors(CGSize(width: shapeWidth, height: shapeHeight), toRect: bounds)
        let xScale = factors.xScalingFactor
        let yScale = factors.yScalingFactor
        
        centerShape(CGSize(width: shapeWidth * xScale, height: shapeHeight * yScale), toRect: bounds)
        
        // Draw the upward arrow
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 28 * xScale, y: 18 * yScale))
        bezierPath.addLine(to: CGPoint(x: 38 * xScale, y: 18 * yScale))
        bezierPath.addLine(to: CGPoint(x: 19 * xScale, y: 0 * yScale))
        bezierPath.addLine(to: CGPoint(x: 0 * xScale, y: 18 * yScale))
        bezierPath.addLine(to: CGPoint(x: 10 * xScale, y: 18 * yScale))
        bezierPath.addLine(to: CGPoint(x: 10 * xScale, y: 28 * yScale))
        bezierPath.addCurve(to: CGPoint(x: 14 * xScale, y: 32 * yScale), controlPoint1: CGPoint(x: 10 * xScale, y: 28 * yScale), controlPoint2: CGPoint(x: 10 * xScale, y: 32 * yScale))
        bezierPath.addCurve(to: CGPoint(x: 24 * xScale, y: 32 * yScale), controlPoint1: CGPoint(x: 16 * xScale, y: 32 * yScale), controlPoint2: CGPoint(x: 24 * xScale, y: 32 * yScale))
        bezierPath.addCurve(to: CGPoint(x: 28 * xScale, y: 28 * yScale), controlPoint1: CGPoint(x: 24 * xScale, y: 32 * yScale), controlPoint2: CGPoint(x: 28 * xScale, y: 32 * yScale))
        bezierPath.addCurve(to: CGPoint(x: 28 * xScale, y: 18 * yScale), controlPoint1: CGPoint(x: 28 * xScale, y: 26 * yScale), controlPoint2: CGPoint(x: 28 * xScale, y: 18 * yScale))
        bezierPath.close()
        color.setFill()
        bezierPath.fill()
        
        // Draw a line under the arrow if shift lock is on
        if drawUnderline {
            let rectanglePath = UIBezierPath(rect: CGRect(x: 10 * xScale, y: 34 * yScale, width: 18 * xScale, height: 4 * yScale))
            color.setFill()
            rectanglePath.fill()
        }
        
        endCenter()
    }
}
