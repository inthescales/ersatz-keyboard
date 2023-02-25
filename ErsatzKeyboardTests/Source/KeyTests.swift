//  Created by Robin Hill on 2/25/23.
//  Copyright © 2023 Apple. All rights reserved.

@testable import ErsatzKeyboard

import SnapshotTesting
import XCTest

class KeyTests: XCTestCase {
    func testCharacterKey() {
        let characters = ["a", "g", "h", "ç", "ñ", "ồ", "A", "Ç", "Ñ", "Ồ", "馬"]
        
        for character in characters {
        let keyView = ImageKey()
            keyView.text = character
            keyView.frame = CGRect(x: 0, y: 0, width: 31.666, height: 43)
            
            let capital = (character.lowercased() != character)
            let suffix = capital ? "_cap" : ""
            let testName = "key_\(character)" + suffix
            assertSnapshot(matching: keyView, as: .image, named: testName)
        }
    }
}
