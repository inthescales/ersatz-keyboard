//  Created by Robin Hill on 2/25/23.
//  Copyright © 2023 Apple. All rights reserved.

@testable import ErsatzKeyboard

import SnapshotTesting
import XCTest

class KeyboardKeyTests: XCTestCase {
    let keyRect = CGRect(x: 0, y: 0, width: 31.666, height: 43)
    let popupSize = CGSize(width: 57.666, height: 57)

    func testCharacterKey() {
        let characters = ["a", "g", "h", "ç", "ñ", "ồ", "A", "Ç", "Ñ", "Ồ", "馬"]
        
        for character in characters {
            let keyView = ImageKey()
            keyView.text = character
            keyView.frame = keyRect
            
            let capital = (character.lowercased() != character)
            let suffix = capital ? "_cap" : ""
            let testName = "key_\(character)" + suffix
            assertSnapshot(matching: keyView, as: .image, named: testName)
        }
    }
    
    func testTappedKey() {
        // Copied from KeyboardLayout 2/25/2023
        // TODO(robin): Find a way to unify these
        func popupFrame(for key: KeyboardKey, direction: Direction) -> CGRect {
            let actualScreenWidth = (UIScreen.main.nativeBounds.size.width / UIScreen.main.nativeScale)
            let totalHeight = self.layoutConstants.popupTotalHeight(actualScreenWidth)
            
            let popupWidth = key.bounds.width + self.layoutConstants.popupWidthIncrement
            let popupHeight = totalHeight - self.layoutConstants.popupGap - key.bounds.height
            
            return CGRect(x: (key.bounds.width - popupWidth) / CGFloat(2), y: -popupHeight - self.layoutConstants.popupGap, width: popupWidth, height: popupHeight)
        }
        
        let keyView = ImageKey()
        keyView.text = "A"
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: max(keyRect.width, popupSize.width), height: keyRect.height + popupSize.height))
        containerView.addSubview(keyView)
        keyView.frame = CGRect(
            x: (containerView.bounds.width - keyRect.width) / 2,
            y: containerView.bounds.height - keyRect.height,
            width: keyRect.width,
            height: keyRect.height
        )
        keyView.showPopup()

        let testName = "key_tapped"
        assertSnapshot(matching: containerView, as: .image, named: testName)
    }
    
    func testShapeKey() {
        let shapeNamePairs: [(String, Shape)] = [
            ("shift", ShiftShape()),
            ("backspace", BackspaceShape()),
            ("globe", GlobeShape())
        ]
        
        for (name, shape) in shapeNamePairs {
            let keyView = ImageKey()
            keyView.shape = shape
            keyView.frame = keyRect
            
            let testName = "key_\(name)"
            assertSnapshot(matching: keyView, as: .image, named: testName)
        }
    }

    func testImageKey() {
        let imageNamePairs = [
            ("settings", UIImage.gear)
        ]
        
        for (name, image) in imageNamePairs {
            let keyView = ImageKey()
            keyView.image = UIImageView(image: image)
            keyView.frame = keyRect
            
            let testName = "key_\(name)"
            assertSnapshot(matching: keyView, as: .image, named: testName)
        }
    }
}
