import SwiftUI

struct ToolbarView: View {
    let language: KeyboardLanguage
    let theme: Theme
    let mode: KeyboardMode
    let onGlobe: () -> Void
    let onLanguageToggle: () -> Void
    let onNumbers: () -> Void
    let onLatin: () -> Void
    let onGeez: () -> Void
    let onSpace: () -> Void
    let onReturn: () -> Void
    let onBackspace: () -> Void

    var body: some View {
        HStack(spacing: 6) {
            globeButton
            languageButton
            modeSwitchButton
            spaceButton
            returnButton
            backspaceButton
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 4)
        .background(theme.keyboardBackground)
    }

    @ViewBuilder
    private var modeSwitchButton: some View {
        switch mode {
        case .geez:
            HStack(spacing: 4) {
                KeyButton(label: Strings.Keyboard.numbers, theme: theme, isSpecial: true, action: onNumbers)
                    .frame(minWidth: 40)
                KeyButton(label: Strings.Keyboard.latin, theme: theme, isSpecial: true, action: onLatin)
                    .frame(minWidth: 40)
            }
        case .latin, .numbers:
            KeyButton(label: Strings.Keyboard.geez, theme: theme, isSpecial: true, action: onGeez)
                .frame(minWidth: 50)
        }
    }

    private var globeButton: some View {
        KeyButton(label: "🌐", theme: theme, isSpecial: true, action: onGlobe)
            .frame(width: 44)
    }

    private var languageButton: some View {
        KeyButton(label: language.shortLabel, theme: theme, isSpecial: true, action: onLanguageToggle)
            .frame(minWidth: 44)
    }

    private var spaceButton: some View {
        KeyButton(label: Strings.Keyboard.space, theme: theme, isSpecial: true, action: onSpace)
            .frame(maxWidth: .infinity)
    }

    private var returnButton: some View {
        KeyButton(label: Strings.Keyboard.returnKey, theme: theme, isSpecial: true, action: onReturn)
            .frame(minWidth: 60)
    }

    private var backspaceButton: some View {
        KeyButton(label: "⌫", theme: theme, isSpecial: true, action: onBackspace)
            .frame(width: 44)
    }
}
