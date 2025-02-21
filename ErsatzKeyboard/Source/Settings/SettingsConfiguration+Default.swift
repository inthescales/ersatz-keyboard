//  Created by Robin Hill on 5/28/22.
//  Copyright © 2022 Apple. All rights reserved.

extension SettingsConfiguration {
    /// A default settings configuration. Includes all settings supported by the ErsatzKeyboard framework, with English labels.
    public static let defaultSettings = SettingsConfiguration(
        titleText: "Settings",
        backText: "Back",
        sections: [
            SettingsSection(
                title: "General Settings",
                rows: [
                    SettingsRow(
                        "Auto-Capitalization",
                        setting: SettingsItem(key: SettingsKey.autoCapitalization, defaultValue: true),
                        note: nil
                    ),
                    SettingsRow(
                        "“.” Shortcut",
                        setting: SettingsItem(key: SettingsKey.periodShortcut, defaultValue: true),
                        note: nil
                    ),
                    SettingsRow(
                        "Keyboard Clicks",
                        setting: SettingsItem(key: SettingsKey.keyboardClicks, defaultValue: false),
                        note: "Please note that keyboard clicks will work only if “Allow Full Access” is enabled in the keyboard settings. Unfortunately, this is a limitation of the operating system."
                    )
                ]
            ),
            SettingsSection(
                title:"Extra Settings",
                rows: [
                    SettingsRow(
                        "Allow Lowercase Key Caps",
                        setting: SettingsItem(key: SettingsKey.smallLowercase, defaultValue: false),
                        note: "Changes your key caps to lowercase when Shift is off, making it easier to tell what mode you are in."
                    )
                ]
            )
        ]
    )
}
