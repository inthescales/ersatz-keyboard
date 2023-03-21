//  Created by Robin Hill on 2/25/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import UIKit

/*
    Archagon's PERFORMANCE NOTES:

    * CAShapeLayer: convenient and low memory usage, but chunky rotations
    * drawRect: fast, but high memory usage (looks like there's a backing store for each of the 3 views)
    * if I set CAShapeLayer to shouldRasterize, perf is *almost* the same as drawRect, while mem usage is the same as before
    * oddly, 3 CAShapeLayers show the same memory usage as 1 CAShapeLayer — where is the backing store?
    * might want to move to drawRect with combined draw calls for performance reasons — not clear yet
*/

/// View that draws the shape of the key – its border and background
class ShapeView: UIView {
    
    var shapeLayer: CAShapeLayer?

    override class var layerClass : AnyClass {
        return CAShapeLayer.self
    }
    
    var curve: UIBezierPath? {
        didSet {
            if let layer = self.shapeLayer {
                layer.path = curve?.cgPath
            }
            else {
                self.setNeedsDisplay()
            }
        }
    }
    
    var fillColor: UIColor? {
        didSet {
            if let layer = self.shapeLayer {
                layer.fillColor = fillColor?.cgColor
            }
            else {
                self.setNeedsDisplay()
            }
        }
    }

    var strokeColor: UIColor? {
        didSet {
            if let layer = self.shapeLayer {
                layer.strokeColor = strokeColor?.cgColor
            }
            else {
                self.setNeedsDisplay()
            }
        }
    }
    
    var lineWidth: CGFloat? {
        didSet {
            if let layer = self.shapeLayer {
                if let lineWidth = self.lineWidth {
                    layer.lineWidth = lineWidth
                }
            }
            else {
                self.setNeedsDisplay()
            }
        }
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.shapeLayer = self.layer as? CAShapeLayer
        
        // optimization: off by default to ensure quick mode transitions; re-enable during rotations
        // self.layer.shouldRasterize = true
        // self.layer.rasterizationScale = UIScreen.mainScreen().scale
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawCall(_ rect:CGRect) {
        if self.shapeLayer == nil {
            if let curve = self.curve {
                if let lineWidth = self.lineWidth {
                    curve.lineWidth = lineWidth
                }
                
                if let fillColor = self.fillColor {
                    fillColor.setFill()
                    curve.fill()
                }
                
                if let strokeColor = self.strokeColor {
                    strokeColor.setStroke()
                    curve.stroke()
                }
            }
        }
    }
}
