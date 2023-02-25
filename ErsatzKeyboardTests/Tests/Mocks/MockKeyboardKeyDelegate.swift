//  Created by Robin Hill on 2/25/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import UIKit

@testable import ErsatzKeyboard

/// Mock class for KeyboardKeyDelegate.
/// Implements popupframe based on standard layout constraints.
final class MockKeyboardKeyDelegate: KeyboardKeyDelegate {
    // Copied from KeyboardLayout 2/25/2023
    // TODO(robin): Find a way to unify these
    func popupFrame(for key: KeyboardKey, direction: Direction) -> CGRect {
        let actualScreenWidth = (UIScreen.main.nativeBounds.size.width / UIScreen.main.nativeScale)
        let totalHeight = LayoutConstants.popupTotalHeight(actualScreenWidth)
        
        let popupWidth = key.bounds.width + LayoutConstants.popupWidthIncrement
        let popupHeight = totalHeight - LayoutConstants.popupGap - key.bounds.height
        
        return CGRect(x: (key.bounds.width - popupWidth) / CGFloat(2), y: -popupHeight - LayoutConstants.popupGap, width: popupWidth, height: popupHeight)
    }
    
    func willShowPopup(for key: KeyboardKey, direction: Direction) {}
    
    func willHidePopup(for key: KeyboardKey) {}
}
