//  Created by Robin Hill on 5/28/22.
//  Copyright © 2022 Apple. All rights reserved.

import Foundation

protocol SettingsProvider {
    /// Assigns default values based on the configuration.
    /// Call this when initializing the provider
    func setDefaults(from: SettingsConfiguration)
    
    /// Returns the value of the setting with the given string, if any
    func value(for: String) -> Bool
    
    /// Assigns the given value to the given string
    func setValue(for: String, to: Bool)
}

final class UserDefaultsSettingsProvider: SettingsProvider {
    func setDefaults(from config: SettingsConfiguration) {
        var defaultSettings = [String: Bool]()
        let settings = config.sections.flatMap { $0.rows }.map { $0.setting }
        settings.forEach { defaultSettings[$0.key] = $0.defaultValue}
        UserDefaults.standard.register(defaults: defaultSettings)
    }

    func value(for key: String) -> Bool {
        UserDefaults.standard.bool(forKey: key)
    }
    
    func setValue(for key: String, to newValue: Bool) {
        UserDefaults.standard.set(newValue, forKey: key)
    }
}
