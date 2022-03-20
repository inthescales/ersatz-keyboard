//
//  Created by Robin Hill on 3/20/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import UIKit

// Default keyboard height values.
fileprivate let iPhonePortraitKeyboardHeight: CGFloat = 216
fileprivate let iPhoneLandscapeKeyboardHeight: CGFloat = 162
fileprivate let iPadPortraitKeyboardHeight: CGFloat = 264
fileprivate let iPadLandscapeKeyboardHeight: CGFloat = 352

/// Type containing data used for simulating a particular device type in test.
struct TestDevice {
    // MARK: - Subtypes
    
    /// The type of device – phone or tablet
    public enum DeviceType {
        case phone, tablet
    }
    
    /// The orientation of the device
    public enum Orientation {
        case portrait, landscape
        
        public var name: String {
            switch self {
            case .portrait:
                return "portrait"
            case .landscape:
                return "landscape"
            }
        }
    }
    
    // MARK: - Properties
    
    /// The name given to this device type
    let name: String
    
    /// The screen dimensions of the device
    private let sizePortrait: CGSize
    
    /// The base height of a keyboard in portrait mode
    private let portraitKeyboardHeight: CGFloat
    
    /// The base height of a keyboard in landscape mode
    private let landscapeKeyboardHeight: CGFloat
    
    /// The type of this device
    let type: DeviceType
    
    /// The current orientation of the device
    var orientation: Orientation = .portrait
    
    // MARK: - Computed properties
    var size: CGSize {
        switch orientation {
        case .portrait:
            return sizePortrait
        case .landscape:
            return CGSize(width: sizePortrait.height, height: sizePortrait.width)
        }
    }
    
    /// The height of the keyboard for this device and orientation
    private var keyboardHeight: CGFloat {
        return orientation == .portrait ? portraitKeyboardHeight : landscapeKeyboardHeight
    }
    
    /// Returns the size of the keyboard on this device in its current orientation
    var keyboardSize: CGSize {
        return CGSize(width: size.width, height: keyboardHeight)
    }
    
    // MARK: - Initializers
    
    init(name: String, size: CGSize, type: DeviceType, orientation: Orientation = .portrait) {
        self.name = name
        self.sizePortrait = size
        self.type = type
        self.orientation = orientation
        
        switch type {
        case .phone:
            self.portraitKeyboardHeight = iPhonePortraitKeyboardHeight
            self.landscapeKeyboardHeight = iPhoneLandscapeKeyboardHeight
        case .tablet:
            self.portraitKeyboardHeight = iPadPortraitKeyboardHeight
            self.landscapeKeyboardHeight = iPadLandscapeKeyboardHeight
        }
    }
    
    // MARK: - Mutating methods
    
    mutating func setOrientation(_ orientation: Orientation) {
        self.orientation = orientation
    }
}

extension TestDevice {
    // iPhones
    
    static let iPhone8 = TestDevice(
        name: "iPhone8",
        size: CGSize(width: 750, height: 1334),
        type: .phone
    )
    
    static let iPhone11 = TestDevice(
        name: "iPhone11",
        size: CGSize(width: 828, height: 1792),
        type: .phone
    )
    
    static let iPhone13ProMax = TestDevice(
        name: "iPhone13ProMax",
        size: CGSize(width: 1284, height: 2778),
        type: .phone
    )

    // iPads
    
    static let iPadPro11Inch = TestDevice(
        name: "iPadPro11Inch",
        size: CGSize(width: 1668, height: 2388),
        type: .phone
    )
    
    static let iPadPro12p9Inch = TestDevice(
        name: "iPadPro12.9Inch",
        size: CGSize(width: 2048, height: 2732),
        type: .phone
    )
}
