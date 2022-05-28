//  Created by Alexei Baboulevitch on 10/5/14.
//  Copyright (c) 2014 Alexei Baboulevitch ("Archagon"). All rights reserved.

import UIKit

/// Locates and draws non-letter shapes on keycaps, such as shift and backspace
/// These shapes were traced and as such are erratic and inaccurate. Consider replacing with SVG or PDF.
class Shape: UIView {
    var color: UIColor? {
        didSet {
            if let _ = self.color {
                setNeedsDisplay()
            }
        }
    }

    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    override required init(frame: CGRect) {
        super.init(frame: frame)
        self.isOpaque = false
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Draw the shape.
    /// Should be overridden by subclasses
    func drawShape(_ color: UIColor) { }

    override func draw(_ rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        CGColorSpaceCreateDeviceRGB()
        ctx?.saveGState()
        drawShape(color ?? .black)
        ctx?.restoreGState()
    }
}

func getFactors(_ fromSize: CGSize, toRect: CGRect) -> (xScalingFactor: CGFloat, yScalingFactor: CGFloat, lineWidthScalingFactor: CGFloat, fillIsHorizontal: Bool, offset: CGFloat) {
    
    let xSize = { () -> CGFloat in
        let scaledSize = (fromSize.width / CGFloat(2))
        if scaledSize > toRect.width {
            return (toRect.width / scaledSize) / CGFloat(2)
        }
        else {
            return CGFloat(0.5)
        }
    }()
    
    let ySize = { () -> CGFloat in
        let scaledSize = (fromSize.height / CGFloat(2))
        if scaledSize > toRect.height {
            return (toRect.height / scaledSize) / CGFloat(2)
        }
        else {
            return CGFloat(0.5)
        }
    }()
    
    let actualSize = min(xSize, ySize)
    
    return (actualSize, actualSize, actualSize, false, 0)
}

func centerShape(_ fromSize: CGSize, toRect: CGRect) {
    let xOffset = (toRect.width - fromSize.width) / CGFloat(2)
    let yOffset = (toRect.height - fromSize.height) / CGFloat(2)
    
    let ctx = UIGraphicsGetCurrentContext()
    ctx?.saveGState()
    ctx?.translateBy(x: xOffset, y: yOffset)
}

func endCenter() {
    let ctx = UIGraphicsGetCurrentContext()
    ctx?.restoreGState()
}
