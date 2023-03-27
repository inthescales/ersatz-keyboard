//  Created by Robin Hill on 5/28/22.
//  Copyright © 2022 Apple. All rights reserved.

/// Configuration for the settings panel
public struct SettingsConfiguration {
    /// Title text to show on the settings panel
    let titleText: String
    
    /// Accessibility text for the setting
    let accessibilityText: String
    
    /// Button text for the back button on the settings panel
    let backText: String
    
    /// Sections of the settings table view
    let sections: [SettingsSection]
    
    public init(titleText: String, accessibilityText: String? = nil, backText: String, sections: [SettingsSection]) {
        self.titleText = titleText
        self.accessibilityText = accessibilityText ?? titleText
        self.backText = backText
        self.sections = sections
    }
}

/// A section of the settings panel's list
public struct SettingsSection {
    let title: String
    let accessibilityText: String
    let rows: [SettingsRow]
    
    public init(title: String, accessibilityText: String? = nil, rows: [SettingsRow]) {
        self.title = title
        self.accessibilityText = accessibilityText ?? title
        self.rows = rows
    }
}

/// A single row of the settings panel's list
public struct SettingsRow {
    let title: String
    let accessibilityText: String
    let setting: SettingsItem
    let note: String?

    public init(_ title: String, accessibilityText: String? = nil, setting: SettingsItem, note: String?) {
        self.title = title
        self.accessibilityText = accessibilityText ?? title
        self.setting = setting
        self.note = note
    }
}
