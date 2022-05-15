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
        let devices: [TestDevice] = [.iPhone8, .iPhone11, .iPhone13ProMax]
        let orientations: [TestDevice.Orientation] = [.portrait, .landscape]
        
        let keyboard = englishKeyboard()
        
        for var device in devices {
            for orientation in orientations {
                device.setOrientation(orientation)
                
                let vc = ErsatzKeyboardViewController(deviceProvider: TestDeviceProvider(device: device))
                vc.keyboard = keyboard
                
                let testView = TestView(device: device, view: vc.view, height: vc.height(orientationIsPortrait: orientation == .portrait, withTopBanner: false))
                let testName = "english_\(device.name)_\(device.orientation.name)"
                
                assertSnapshot(matching: testView, as: .image, named: testName)
            }
        }
    }
}
