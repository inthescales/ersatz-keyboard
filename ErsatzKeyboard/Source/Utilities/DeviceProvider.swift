//
//  DeviceProvider.swift
//  ErsatzKeyboard
//
//  Created by Robin Hill on 2/26/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import UIKit

protocol DeviceProvider {
    var scale: CGFloat { get }
    var bounds: CGRect { get }
    
    var nativeScale: CGFloat { get }
    var nativeBounds: CGRect { get }
    
    var isIPad: Bool { get }
}

final class MainScreenDeviceProvider: DeviceProvider {
    var scale: CGFloat {
        UIScreen.main.scale
    }
    
    var bounds: CGRect {
        UIScreen.main.bounds
    }
    
    var nativeScale: CGFloat {
        UIScreen.main.nativeScale
    }
    
    var nativeBounds: CGRect {
        UIScreen.main.nativeBounds
    }
    
    var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
    }
}
