//  Created by Robin Hill on 3/20/23.
//  Copyright © 2023 Apple. All rights reserved.

@testable import ErsatzKeyboard
import UIKit

final class TestDeviceProvider: DeviceProvider {
    let scale: CGFloat
    let bounds: CGRect
    let nativeScale: CGFloat
    let nativeBounds: CGRect
    let isIPad: Bool
    
    init(
        scale: CGFloat,
        bounds: CGRect,
        nativeScale: CGFloat?,
        nativeBounds: CGRect?,
        isIPad: Bool
    ) {
        self.scale = scale
        self.bounds = bounds
        self.nativeScale = nativeScale ?? scale
        self.nativeBounds = nativeBounds ?? bounds
        self.isIPad = isIPad
    }
}
