//
//  ErsatzKeyboardTests.swift
//  ErsatzKeyboardTests
//
//  Created by Robin Hill on 3/20/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import XCTest

import ErsatzKeyboard
import SnapshotTesting

class ErsatzKeyboardTests: XCTestCase {
    func testEnglishiPhone() {
        let devices: [TestDevice] = [.iPhone11]
        let orientations: [TestDevice.Orientation] = [.portrait]
        
        let keyboard = englishKeyboard()
        let vc = ErsatzKeyboardViewController()
        vc.keyboard = keyboard
        
        for var device in devices {
            for orientation in orientations {
                device.setOrientation(orientation)
                let testView = TestView(device: device, view: vc.view)
                let testName = "english_\(device.name)_\(device.orientation.name)"
                
                assertSnapshot(matching: testView, as: .image, named: testName)
            }
        }
    }
}
