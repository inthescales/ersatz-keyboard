//  Created by Alexei Baboulevitch on 11/2/14.
//  Copyright (c) 2014 Alexei Baboulevitch ("Archagon"). All rights reserved.
//

import UIKit

public class ImageKey: KeyboardKey {
    
    public var image: UIImageView? {
        willSet {
            let anImage = image
            anImage?.removeFromSuperview()
        }
        didSet {
            if let imageView = image {
                self.addSubview(imageView)
                imageView.contentMode = UIView.ContentMode.scaleAspectFit
                self.redrawImage()
                updateColors()
            }
        }
    }
    
    public override func updateColors() {
        super.updateColors()
        
        let switchColors = self.isHighlighted || self.isSelected
        
        if switchColors {
            if let downTextColor = colors.downTextColor {
                self.image?.tintColor = downTextColor
            }
            else {
                self.image?.tintColor = colors.textColor
            }
        }
        else {
            self.image?.tintColor = colors.textColor
        }
    }
    
    public override func refreshShapes() {
        super.refreshShapes()
        self.redrawImage()
    }
    
    public func redrawImage() {
        if let image = self.image {
            let imageSize = CGSize(width: 20, height: 20)
            let imageOrigin = CGPoint(
                x: (self.bounds.width - imageSize.width) / CGFloat(2),
                y: (self.bounds.height - imageSize.height) / CGFloat(2))
            var imageFrame = CGRect.zero
            imageFrame.origin = imageOrigin
            imageFrame.size = imageSize
            
            image.frame = imageFrame
        }
    }
}
