//  Created by Robin Hill on 5/28/22.
//  Copyright © 2022 Apple. All rights reserved.

/// Configuration for the settings panel
public struct SettingsConfiguration {
    let sections: [SettingsSection]
    
    public init(sections: [SettingsSection]) {
        self.sections = sections
    }
}

/// A section of the settings panel's list
public struct SettingsSection {
    let title: String
    let rows: [SettingsRow]
    
    init(title: String, rows: [SettingsRow]) {
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
