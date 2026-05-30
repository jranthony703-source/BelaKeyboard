import SwiftUI
import Combine

/// Reads and writes the active theme via App Group UserDefaults.
final class ThemeManager: ObservableObject {
    static let shared = ThemeManager()

    @Published private(set) var activeTheme: Theme
    @Published private(set) var isPremiumUnlocked: Bool

    private init() {
        let themeID = SharedDefaults.string(for: SharedDefaults.Key.activeTheme) ?? Theme.light.id
        activeTheme = Theme.theme(for: themeID)
        isPremiumUnlocked = SharedDefaults.bool(for: SharedDefaults.Key.premiumUnlocked)
    }

    func refresh() {
        let themeID = SharedDefaults.string(for: SharedDefaults.Key.activeTheme) ?? Theme.light.id
        activeTheme = Theme.theme(for: themeID)
        isPremiumUnlocked = SharedDefaults.bool(for: SharedDefaults.Key.premiumUnlocked)
    }

    func setActiveTheme(_ theme: Theme) {
        guard !theme.isPremium || isPremiumUnlocked else { return }
        activeTheme = theme
        SharedDefaults.set(theme.id, for: SharedDefaults.Key.activeTheme)
        AppGroupNotifier.postThemeChanged()
    }

    func canUse(_ theme: Theme) -> Bool {
        !theme.isPremium || isPremiumUnlocked
    }

    func setPremiumUnlocked(_ unlocked: Bool) {
        isPremiumUnlocked = unlocked
        SharedDefaults.set(unlocked, for: SharedDefaults.Key.premiumUnlocked)
        if !unlocked, activeTheme.isPremium {
            setActiveTheme(.light)
        }
        AppGroupNotifier.postPremiumChanged()
    }
}
