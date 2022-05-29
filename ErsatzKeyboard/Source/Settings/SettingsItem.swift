//  Created by Robin Hill on 5/28/22.
//  Copyright © 2022 Apple. All rights reserved.

import Foundation

public struct SettingsItem {
    public let key: String
    public let defaultValue: Bool
    
    public init(key: String, defaultValue: Bool) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    // Default settings
    public static let autoCapitalization = SettingsItem(key: "kAutoCapitalization", defaultValue: true)
    public static let periodShortcut = SettingsItem(key: "kPeriodShortcut", defaultValue: true)
    public static let keyboardClicks = SettingsItem(key: "kKeyboardClicks", defaultValue: false)
    public static let smallLowercase = SettingsItem(key: "kSmallLowercase", defaultValue: false)
}
