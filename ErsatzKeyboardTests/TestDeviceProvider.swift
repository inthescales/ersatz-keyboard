//
//  Created by Robin Hill on 3/21/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import UIKit

import ErsatzKeyboard

final class TestDeviceProvider: DeviceProvider {
    let device: TestDevice
    
    init(device: TestDevice) {
        self.device = device
    }
    
    // MARK: - DeviceProvider
    
    var size: CGSize {
        return device.size
    }
    
    var nativeSize: CGSize {
        return device.size
    }
    
    var scale: CGFloat {
        return device.scale
    }
    
    var nativeScale: CGFloat {
        return device.nativeScale
    }
    
    var userInterfaceIdiom: UIUserInterfaceIdiom {
        switch device.type {
        case .phone:
            return .phone
        case .tablet:
            return .pad
        }
    }
}
