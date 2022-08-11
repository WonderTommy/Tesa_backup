//
//  UserDefaultsPlus.swift
//  Tesa
//
//  Created by Hao Li on 2022-07-24.
//

import Foundation

class SettingsUserDefaults {
    enum Keys {
        case DefaultFrequency
        case ExcludeEmptyBar
    }
    public static let value: [Keys: String] = [
        .DefaultFrequency: "SETTINGS_DEFAULT_FREQUENCY",
        .ExcludeEmptyBar: "SETTINGS_EXCLUDE_EMPTY_BAR"
    ]
}


extension UserDefaults {
    public static func getDefaultFrequency() -> Frequency {
        let mode = self.standard.integer(forKey: SettingsUserDefaults.value[.DefaultFrequency]!)
        return Frequency(rawValue: mode)
    }
    public static func setDefaultFrequency(frequency: Frequency) {
        self.standard.set(frequency.mode, forKey: SettingsUserDefaults.value[.DefaultFrequency]!)
    }
    public static func setDefaultFrequency(mode: Frequency.Mode) {
        self.standard.set(mode.rawValue, forKey: SettingsUserDefaults.value[.DefaultFrequency]!)
    }
    
    public static func getExcludeEmptyBar() -> Bool {
        return self.standard.bool(forKey: SettingsUserDefaults.value[.ExcludeEmptyBar]!)
    }
    public static func setExcludeEmptyBar(_ value: Bool) {
        self.standard.set(value, forKey: SettingsUserDefaults.value[.ExcludeEmptyBar]!)
    }
}
