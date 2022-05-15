//
//  Created by Robin Hill on 3/21/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import UIKit

/// Protocol for getting data about the active device
public protocol DeviceProvider {
    /// The size of the screen
    var size: CGSize { get }
    
    var nativeSize: CGSize { get }
    
    var scale: CGFloat { get }
    
    var nativeScale: CGFloat { get }
    
    /// The current interface idiom of the device
    var userInterfaceIdiom: UIUserInterfaceIdiom { get }
}

public final class ActualDeviceProvider: DeviceProvider {
    public var size: CGSize {
        return UIScreen.main.bounds.size
    }
    
    public var nativeSize: CGSize {
        return UIScreen.main.nativeBounds.size
    }
    
    public var scale: CGFloat {
        return UIScreen.main.scale
    }
    
    public var nativeScale: CGFloat {
        return UIScreen.main.nativeScale
    }
    
    public var userInterfaceIdiom: UIUserInterfaceIdiom {
        return UIDevice.current.userInterfaceIdiom
    }
    
    public init() {}
}
