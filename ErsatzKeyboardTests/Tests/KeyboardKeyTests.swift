//  Created by Robin Hill on 2/25/23.
//  Copyright © 2023 Apple. All rights reserved.

@testable import ErsatzKeyboard

import SnapshotTesting
import XCTest

class KeyboardKeyTests: XCTestCase {
    let keyRect = CGRect(x: 0, y: 0, width: 31.666, height: 43)
    let popupSize = CGSize(width: 57.666, height: 57)

    /// Displays a single keyboard key, displaying a character
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
    
    /// Displays a tapped keyboard key, showing its popup
    /// Note: Shadows cannot currently be rendered in snapshot tests without a host application
    func testTappedKey() {
        let keyDelegate = MockKeyboardKeyDelegate()
        let keyView = ImageKey()
        keyView.text = "A"
        keyView.delegate = keyDelegate
        
        let containerView = UIView(frame:
            CGRect(
                x: 0,
                y: 0,
                width: max(keyRect.width, popupSize.width),
                height: 112
            )
        )
        containerView.backgroundColor = .lightGray
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
    
    /// Displays a single key, showing a shape
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

    /// Displays a single key, showing an image
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
