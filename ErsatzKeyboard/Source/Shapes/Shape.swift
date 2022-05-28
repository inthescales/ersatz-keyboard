//  Created by Alexei Baboulevitch on 10/5/14.
//  Copyright (c) 2014 Alexei Baboulevitch ("Archagon"). All rights reserved.

import UIKit

/// Locates and draws non-letter shapes on keycaps, such as shift and backspace
/// These shapes were traced and as such are erratic and inaccurate. Consider replacing with SVG or PDF.
class Shape: UIView {
    /// The stroke and fill color for drawing the shape.
    var color: UIColor? {
        didSet {
            if let _ = self.color {
                setNeedsDisplay()
            }
        }
    }
    
    /// The natural size of the shape being drawn.
    var baseSize: CGSize {
        CGSize(width: 44, height: 32)
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
    
    /// Returns a scaling factor needed to draw an image with the base size into the given rect.
    func getScaleFactor(for drawRect: CGRect) -> CGFloat {
        let xSize = { () -> CGFloat in
            let scaledSize = (baseSize.width / CGFloat(2))
            if scaledSize > drawRect.width {
                return (drawRect.width / scaledSize) / CGFloat(2)
            }
            else {
                return CGFloat(0.5)
            }
        }()
        
        let ySize = { () -> CGFloat in
            let scaledSize = (baseSize.height / CGFloat(2))
            if scaledSize > drawRect.height {
                return (drawRect.height / scaledSize) / CGFloat(2)
            }
            else {
                return CGFloat(0.5)
            }
        }()
        
        return min(xSize, ySize)
    }
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
