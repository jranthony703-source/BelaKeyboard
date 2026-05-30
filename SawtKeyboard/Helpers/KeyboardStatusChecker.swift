import UIKit

/// Checks whether Sawt Keyboard appears in the user's enabled keyboards list.
enum KeyboardStatusChecker {
    static func isKeyboardEnabled() -> Bool {
        guard let keyboards = UserDefaults.standard.dictionaryRepresentation()["AppleKeyboards"] as? [String] else {
            return false
        }
        return keyboards.contains { $0.contains("SawtKeyboardExtension") || $0.contains("SawtKeyboard") }
    }
}
