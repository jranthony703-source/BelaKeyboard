import Foundation

/// Darwin notifications so the keyboard extension picks up app changes instantly.
enum AppGroupNotifier {
    private static let themeName = CFNotificationName("com.sawtKeyboard.themeChanged" as CFString)
    private static let premiumName = CFNotificationName("com.sawtKeyboard.premiumChanged" as CFString)

    static var themeHandler: (() -> Void)?
    static var premiumHandler: (() -> Void)?

    private static let observerCallback: CFNotificationCallback = { _, _, name, _, _ in
        guard let name else { return }
        DispatchQueue.main.async {
            if name == AppGroupNotifier.themeName {
                AppGroupNotifier.themeHandler?()
            } else if name == AppGroupNotifier.premiumName {
                AppGroupNotifier.premiumHandler?()
            }
        }
    }

    static func postThemeChanged() {
        CFNotificationCenterPostNotification(
            CFNotificationCenterGetDarwinNotifyCenter(),
            themeName, nil, nil, true
        )
    }

    static func postPremiumChanged() {
        CFNotificationCenterPostNotification(
            CFNotificationCenterGetDarwinNotifyCenter(),
            premiumName, nil, nil, true
        )
    }

    static func startObserving(theme: @escaping () -> Void, premium: @escaping () -> Void) {
        themeHandler = theme
        premiumHandler = premium
        let center = CFNotificationCenterGetDarwinNotifyCenter()
        CFNotificationCenterAddObserver(
            center, nil, observerCallback,
            themeName.rawValue, nil, .deliverImmediately
        )
        CFNotificationCenterAddObserver(
            center, nil, observerCallback,
            premiumName.rawValue, nil, .deliverImmediately
        )
    }
}
