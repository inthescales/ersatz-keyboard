//  Created by Robin Hill on 2/25/23.
//  Copyright © 2023 Apple. All rights reserved.

@testable import ErsatzKeyboard

import SnapshotTesting
import XCTest

class KeyboardKeyTests: XCTestCase {
    let keyRect = CGRect(x: 0, y: 0, width: 31.666, height: 43)

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
