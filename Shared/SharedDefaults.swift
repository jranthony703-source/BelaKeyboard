import Foundation

/// Central access point for App Group UserDefaults shared between app and extension.
enum SharedDefaults {
    static let appGroupID = "group.com.sawtKeyboard.shared"

    enum Key {
        static let activeTheme = "activeTheme"
        static let premiumUnlocked = "premiumUnlocked"
        static let defaultLanguage = "defaultLanguage"
        static let lastLanguage = "lastLanguage"
    }

    static var suite: UserDefaults {
        UserDefaults(suiteName: appGroupID) ?? .standard
    }

    static func string(for key: String) -> String? {
        suite.string(forKey: key)
    }

    static func set(_ value: String?, for key: String) {
        suite.set(value, forKey: key)
        suite.synchronize()
    }

    static func bool(for key: String) -> Bool {
        suite.bool(forKey: key)
    }

    static func set(_ value: Bool, for key: String) {
        suite.set(value, forKey: key)
        suite.synchronize()
    }
}
