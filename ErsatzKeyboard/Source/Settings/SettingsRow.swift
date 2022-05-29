//  Created by Robin Hill on 5/28/22.
//  Copyright © 2022 Apple. All rights reserved.

/// Describes a row on the settings screen
enum SettingsRow {
    case toggle(_ title: String, setting: String, notes: String?)
    case info(_ title: String, notes: String?)
}
