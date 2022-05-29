//  Created by Robin Hill on 5/28/22.
//  Copyright © 2022 Apple. All rights reserved.

import Foundation

/// Represents a single item in the keyboard's settings.
/// Use new instances of this type to add settings that aren't part of ErsatzKeyboard's framework.
public struct SettingsItem {
    /// A unique string key to identify this setting
    public let key: String
    
    /// A default value to assign to this setting
    public let defaultValue: Bool
    
    public init(key: String, defaultValue: Bool) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    // Settings used by ErsatzKeyboard
    
    /// Setting for autocapitalizing words at the start of a sentence
    public static let autoCapitalization = SettingsItem(key: "kAutoCapitalization", defaultValue: true)
    
    /// Setting for a shortcut to insert a period after two consecutive spaces
    public static let periodShortcut = SettingsItem(key: "kPeriodShortcut", defaultValue: true)
    
    /// Setting to play keyboard click sound effects
    public static let keyboardClicks = SettingsItem(key: "kKeyboardClicks", defaultValue: false)
    
    /// Setting to display lowercase letters on keycaps if shift is not on
    public static let smallLowercase = SettingsItem(key: "kSmallLowercase", defaultValue: false)
}
