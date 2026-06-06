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
    let onEmoji: () -> Void
    let onSpace: () -> Void
    let onReturn: () -> Void
    let onBackspace: () -> Void

    var body: some View {
        HStack(spacing: 5) {
            globeButton
            languageButton
            modeSwitchButton
            spaceButton
            returnButton
            backspaceButton
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 5)
        .background(theme.keyboardBackground)
    }

    @ViewBuilder
    private var modeSwitchButton: some View {
        switch mode {
        case .geez:
            HStack(spacing: 4) {
                KeyButton(label: Strings.Keyboard.numbers, theme: theme, isSpecial: true, hapticStrength: .medium, fontSize: 15, action: onNumbers)
                    .frame(width: 36)
                KeyButton(label: Strings.Keyboard.latin, theme: theme, isSpecial: true, hapticStrength: .medium, fontSize: 14, action: onLatin)
                    .frame(width: 38)
                KeyButton(label: Strings.Keyboard.emoji, theme: theme, isSpecial: true, hapticStrength: .medium, fontSize: 18, action: onEmoji)
                    .frame(width: 36)
            }
        case .latin, .numbers, .emoji:
            KeyButton(label: Strings.Keyboard.geez, theme: theme, isSpecial: true, hapticStrength: .medium, fontSize: 16, action: onGeez)
                .frame(minWidth: 52)
        }
    }

    private var globeButton: some View {
        KeyButton(label: "🌐", theme: theme, isSpecial: true, hapticStrength: .medium, fontSize: 18, action: onGlobe)
            .frame(width: 40)
    }

    private var languageButton: some View {
        KeyButton(label: language.shortLabel, theme: theme, isSpecial: true, hapticStrength: .medium, fontSize: 16, action: onLanguageToggle)
            .frame(width: 40)
    }

    private var spaceButton: some View {
        KeyButton(label: Strings.Keyboard.space, theme: theme, isSpecial: true, hapticStrength: .medium, fontSize: 15, action: onSpace)
            .frame(maxWidth: .infinity)
    }

    private var returnButton: some View {
        KeyButton(label: Strings.Keyboard.returnKey, theme: theme, isSpecial: true, hapticStrength: .medium, fontSize: 15, action: onReturn)
            .frame(width: 56)
    }

    private var backspaceButton: some View {
        BackspaceKeyButton(theme: theme, onDelete: onBackspace)
            .frame(width: 40)
    }
}

// MARK: - Backspace with long-press repeat

struct BackspaceKeyButton: View {
    let theme: Theme
    let onDelete: () -> Void

    @StateObject private var repeater = BackspaceRepeater()
    @State private var isPressed = false

    var body: some View {
        Text("⌫")
            .font(.system(size: 20))
            .foregroundColor(theme.keyText)
            .frame(maxWidth: .infinity, minHeight: 43)
            .keyFace(base: theme.specialKeyBackground, pressed: isPressed)
            .scaleEffect(isPressed ? 0.93 : 1.0)
            .animation(.easeOut(duration: 0.08), value: isPressed)
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        guard !isPressed else { return }
                        isPressed = true
                        repeater.onDelete = onDelete
                        repeater.startPress()
                    }
                    .onEnded { _ in
                        isPressed = false
                        repeater.endPress()
                    }
            )
    }
}

@MainActor
final class BackspaceRepeater: ObservableObject {
    var onDelete: (() -> Void)?

    private var initialDelayTask: Task<Void, Never>?
    private var repeatTimer: Timer?
    private var pressStartTime: Date?
    private var currentInterval: TimeInterval = 0.1

    func startPress() {
        guard pressStartTime == nil else { return }
        pressStartTime = Date()
        HapticManager.tap(.medium)
        onDelete?()

        initialDelayTask = Task { @MainActor [weak self] in
            try? await Task.sleep(nanoseconds: 400_000_000)
            guard !Task.isCancelled, let self else { return }
            self.startRepeating(interval: 0.1)
        }
    }

    private func startRepeating(interval: TimeInterval) {
        currentInterval = interval
        repeatTimer?.invalidate()
        repeatTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                guard let self else { return }
                self.onDelete?()
                HapticManager.tap(.light)
                if let start = self.pressStartTime,
                   Date().timeIntervalSince(start) > 1.5,
                   self.currentInterval > 0.05 {
                    self.startRepeating(interval: 0.05)
                }
            }
        }
    }

    func endPress() {
        initialDelayTask?.cancel()
        initialDelayTask = nil
        repeatTimer?.invalidate()
        repeatTimer = nil
        pressStartTime = nil
    }
}
