//  Created by Robin Hill on 2/25/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import UIKit

/// Color theme for a keyboard key
struct KeyboardKeyColors {
    let capColor: UIColor
    let underColor: UIColor
    let borderColor: UIColor
    let textColor: UIColor
    
    let downColor: UIColor?
    let downUnderColor: UIColor?
    let downBorderColor: UIColor?
    let downTextColor: UIColor?
    
    let popupColor: UIColor?
    
    init(
        capColor: UIColor,
        underColor: UIColor,
        borderColor: UIColor,
        textColor: UIColor,
        downColor: UIColor? = nil,
        downUnderColor: UIColor? = nil,
        downBorderColor: UIColor? = nil,
        downTextColor: UIColor? = nil,
        popupColor: UIColor? = nil
    ) {
        self.capColor = capColor
        self.underColor = underColor
        self.borderColor = borderColor
        self.textColor = textColor
        self.downColor = downColor
        self.downUnderColor = downUnderColor
        self.downBorderColor = downBorderColor
        self.downTextColor = downTextColor
        self.popupColor = popupColor
    }
    
    static var standard = {
        KeyboardKeyColors(
            capColor: .white,
            underColor: .gray,
            borderColor: .black,
            textColor: .black,
            popupColor: .white
        )
    }()
    
    static func character(
        _ globalColors: GlobalColors.Type,
        darkMode: Bool,
        solidColorMode: Bool = false,
        isIPad: Bool = false
    ) -> KeyboardKeyColors {
        KeyboardKeyColors(
            capColor: globalColors.regularKey(darkMode, solidColorMode: solidColorMode),
            underColor: standardUnderColor(globalColors, darkMode: darkMode),
            borderColor: standardBorderColor(globalColors, darkMode: darkMode),
            textColor: darkMode ? globalColors.darkModeTextColor : globalColors.lightModeTextColor,
            downColor: isIPad ? globalColors.specialKey(darkMode, solidColorMode: solidColorMode) : nil,
            popupColor: standardPopupColor(globalColors, darkMode: darkMode, solidColorMode: solidColorMode)
        )
    }
    
    static func space(
        _ globalColors: GlobalColors.Type,
        darkMode: Bool,
        solidColorMode: Bool
    ) -> KeyboardKeyColors {
        KeyboardKeyColors(
            capColor: globalColors.regularKey(darkMode, solidColorMode: solidColorMode),
            underColor: standardUnderColor(globalColors, darkMode: darkMode),
            borderColor: standardBorderColor(globalColors, darkMode: darkMode),
            textColor: darkMode ? globalColors.darkModeTextColor : globalColors.lightModeTextColor,
            downColor: globalColors.specialKey(darkMode, solidColorMode: solidColorMode)
        )
    }
    
    static func shift(
        _ globalColors: GlobalColors.Type,
        darkMode: Bool,
        solidColorMode: Bool
    ) -> KeyboardKeyColors {
        KeyboardKeyColors(
            capColor: globalColors.specialKey(darkMode, solidColorMode: solidColorMode),
            underColor: standardUnderColor(globalColors, darkMode: darkMode),
            borderColor: standardBorderColor(globalColors, darkMode: darkMode),
            textColor: globalColors.darkModeTextColor,
            downColor: darkMode ? globalColors.darkModeShiftKeyDown : globalColors.lightModeRegularKey,
            downTextColor: globalColors.lightModeTextColor
        )
    }
    
    static func backspace(
        _ globalColors: GlobalColors.Type,
        darkMode: Bool,
        solidColorMode: Bool
    ) -> KeyboardKeyColors {
        // TODO: actually a bit different
        KeyboardKeyColors(
            capColor: globalColors.specialKey(darkMode, solidColorMode: solidColorMode),
            underColor: standardUnderColor(globalColors, darkMode: darkMode),
            borderColor: standardBorderColor(globalColors, darkMode: darkMode),
            textColor: globalColors.darkModeTextColor,
            downColor: globalColors.regularKey(darkMode, solidColorMode: solidColorMode),
            downTextColor: darkMode ? nil : globalColors.lightModeTextColor
        )
    }
    
    static func modeChange(
        _ globalColors: GlobalColors.Type,
        darkMode: Bool,
        solidColorMode: Bool
    ) -> KeyboardKeyColors {
        KeyboardKeyColors(
            capColor: globalColors.specialKey(darkMode, solidColorMode: solidColorMode),
            underColor: standardUnderColor(globalColors, darkMode: darkMode),
            borderColor: standardBorderColor(globalColors, darkMode: darkMode),
            textColor: darkMode ? globalColors.darkModeTextColor : globalColors.lightModeTextColor
        )
    }
    
    static func action(
        _ globalColors: GlobalColors.Type,
        darkMode: Bool,
        solidColorMode: Bool
    ) -> KeyboardKeyColors {
        // TODO: actually a bit different
        KeyboardKeyColors(
            capColor: globalColors.specialKey(darkMode, solidColorMode: solidColorMode),
            underColor: standardUnderColor(globalColors, darkMode: darkMode),
            borderColor: standardBorderColor(globalColors, darkMode: darkMode),
            textColor: darkMode ? globalColors.darkModeTextColor : globalColors.lightModeTextColor,
            downColor: globalColors.regularKey(darkMode, solidColorMode: solidColorMode)
        )
    }
    
    // MARK: - Standard Colors
    
    private static func standardUnderColor(_ globalColors: GlobalColors.Type, darkMode: Bool) -> UIColor {
        darkMode ? globalColors.darkModeUnderColor : globalColors.lightModeUnderColor
    }
    
    private static func standardBorderColor(_ globalColors: GlobalColors.Type, darkMode: Bool) -> UIColor {
        darkMode ? globalColors.darkModeBorderColor : globalColors.lightModeBorderColor
    }
    
    private static func standardPopupColor(
        _ globalColors: GlobalColors.Type,
        darkMode: Bool,
        solidColorMode: Bool
    ) -> UIColor {
        globalColors.popup(darkMode, solidColorMode: solidColorMode)
    }
    
}
