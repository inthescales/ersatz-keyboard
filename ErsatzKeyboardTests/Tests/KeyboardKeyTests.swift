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
            for darkMode in [false, true] {
                let keyView = ImageKey()
                keyView.text = character
                keyView.colors = .character(GlobalColors.self, darkMode: darkMode)
                keyView.frame = keyRect
                
                let capital = (character.lowercased() != character)
                let capSuffix = capital ? "_cap" : ""
                let colorSuffix = darkMode ? "_dark" : "_light"
                let testName = "key_\(character)" + capSuffix + colorSuffix
                assertSnapshot(matching: keyView, as: .image, named: testName)
            }
        }
    }
    
    /// Displays a tapped keyboard key, showing its popup
    /// Note: Shadows cannot currently be rendered in snapshot tests without a host application
    func testTappedKey() {
        for darkMode in [false, true] {
            let keyDelegate = MockKeyboardKeyDelegate(deviceProvider: MainScreenDeviceProvider())
            let keyView = ImageKey()
            keyView.text = "A"
            keyView.colors = .character(GlobalColors.self, darkMode: darkMode)
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

            let colorSuffix = darkMode ? "_dark" : "_light"
            let testName = "key_tapped" + colorSuffix
            assertSnapshot(matching: containerView, as: .image, named: testName)
        }
    }
    
    /// Displays a single key, showing a shape
    func testShapeKey() {
        let shapeInfo: [(String, Shape, KeyboardKeyColors, KeyboardKeyColors)] = [
            (
                "shift",
                ShiftShape(),
                .shift(GlobalColors.self, darkMode: false, solidColorMode: false),
                .shift(GlobalColors.self, darkMode: true, solidColorMode: false)
            ),
            (
                "backspace",
                BackspaceShape(),
                .backspace(GlobalColors.self, darkMode: false, solidColorMode: false),
                .backspace(GlobalColors.self, darkMode: true, solidColorMode: false)
            ),
            (
                "globe",
                GlobeShape(),
                .action(GlobalColors.self, darkMode: false, solidColorMode: false),
                .action(GlobalColors.self, darkMode: true, solidColorMode: false)
            )
        ]
        
        for (name, shape, lightColors, darkColors) in shapeInfo {
            for darkMode in [false, true] {
                let keyView = ImageKey()
                keyView.shape = shape
                keyView.colors = darkMode ? darkColors : lightColors
                keyView.frame = keyRect
                
                let colorSuffix = darkMode ? "_dark" : "_light"
                let testName = "key_\(name)" + colorSuffix
                assertSnapshot(matching: keyView, as: .image, named: testName)
            }
        }
    }

    /// Displays a single key, showing an image
    func testImageKey() {
        let imageInfo: [(String, UIImage, KeyboardKeyColors, KeyboardKeyColors)] = [
            (
                "settings",
                UIImage.gear!,
                .action(GlobalColors.self, darkMode: false, solidColorMode: false),
                .action(GlobalColors.self, darkMode: true, solidColorMode: false)
            )
        ]
        
        for (name, image, lightColors, darkColors) in imageInfo {
            for darkMode in [false, true] {
                let keyView = ImageKey()
                keyView.image = UIImageView(image: image)
                keyView.colors = darkMode ? darkColors : lightColors
                keyView.frame = keyRect
                
                let colorSuffix = darkMode ? "_dark" : "_light"
                let testName = "key_\(name)" + colorSuffix
                assertSnapshot(matching: keyView, as: .image, named: testName)
            }
        }
    }
}
