//  Created by Robin Hill on 5/28/22.
//  Copyright © 2022 Apple. All rights reserved.

/// Configuration for the settings panel
public struct SettingsConfiguration {
    /// Title text to show on the settings panel
    let titleText: String
    
    /// Button text for the back button on the settings panel
    let backText: String
    
    /// Sections of the settings table view
    let sections: [SettingsSection]
    
    public init(titleText: String, backText: String, sections: [SettingsSection]) {
        self.titleText = titleText
        self.backText = backText
        self.sections = sections
    }
}

/// A section of the settings panel's list
public struct SettingsSection {
    let title: String
    let rows: [SettingsRow]
    
    public init(title: String, rows: [SettingsRow]) {
        self.title = title
        self.rows = rows
    }
}

/// A single row of the settings panel's list
public struct SettingsRow {
    let title: String
    let setting: SettingsItem
    let note: String?

    public init(_ title: String, setting: SettingsItem, note: String?) {
        self.title = title
        self.setting = setting
        self.note = note
    }
}
