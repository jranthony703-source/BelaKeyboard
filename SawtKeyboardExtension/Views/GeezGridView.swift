import SwiftUI

struct GeezGridView: View {
    let theme: Theme
    let activeConsonant: GeezConsonant?
    let onConsonantTap: (GeezConsonant) -> Void
    let onBackgroundTap: () -> Void

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 6), count: 8)

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 6) {
                ForEach(GeezConsonant.allCases) { consonant in
                    KeyButton(
                        label: consonant.baseCharacter,
                        theme: theme,
                        isHighlighted: activeConsonant == consonant,
                        isSpecial: false
                    ) {
                        onConsonantTap(consonant)
                    }
                }
            }
            .padding(.horizontal, 5)
            .padding(.vertical, 6)
        }
        .contentShape(Rectangle())
        .onTapGesture { onBackgroundTap() }
    }
}

// MARK: - Key button

struct KeyButton: View {
    let label: String
    let theme: Theme
    var isHighlighted: Bool = false
    var isSpecial: Bool = false
    var hapticStrength: HapticManager.Strength = .light
    var fontSize: CGFloat = 22
    /// When true, a magnified character bubble pops above the key on press (iOS-style).
    var showsPop: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: fontSize, weight: .regular))
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
        .buttonStyle(
            PressableKeyStyle(
                theme: theme,
                isSpecial: isSpecial,
                isHighlighted: isHighlighted,
                hapticStrength: hapticStrength,
                popLabel: showsPop ? label : nil
            )
        )
    }
}

struct PressableKeyStyle: ButtonStyle {
    let theme: Theme
    var isSpecial: Bool = false
    var isHighlighted: Bool = false
    var hapticStrength: HapticManager.Strength = .light
    /// If set, pressing the key shows a magnified preview bubble above it.
    var popLabel: String? = nil

    func makeBody(configuration: Configuration) -> some View {
        let base = isSpecial ? theme.specialKeyBackground : theme.keyBackground
        configuration.label
            .foregroundColor(theme.keyText)
            .frame(maxWidth: .infinity, minHeight: 43)
            .keyFace(base: base, pressed: configuration.isPressed)
            .overlay(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(isHighlighted ? theme.keyText.opacity(0.6) : .clear, lineWidth: 2)
            )
            .overlay(alignment: .top) {
                if let popLabel, configuration.isPressed {
                    KeyPopBubble(text: popLabel, theme: theme)
                        .offset(y: -54)
                        .allowsHitTesting(false)
                        .transition(.opacity)
                }
            }
            .scaleEffect(configuration.isPressed ? 0.93 : 1.0)
            .zIndex(configuration.isPressed ? 20 : 0)
            .animation(.easeOut(duration: 0.08), value: configuration.isPressed)
            .onChange(of: configuration.isPressed) { pressed in
                if pressed { HapticManager.tap(hapticStrength) }
            }
    }
}

/// The magnified character bubble shown above a pressed key.
struct KeyPopBubble: View {
    let text: String
    let theme: Theme

    var body: some View {
        Text(text)
            .font(.system(size: 30))
            .foregroundColor(theme.keyText)
            .frame(width: 48, height: 52)
            .keyFace(base: theme.keyBackground, cornerRadius: 11)
    }
}

// MARK: - Glossy key face (shared by all keys)

/// Gives any key a premium look: base color + top gloss highlight +
/// bottom depth shadow + a crisp drop shadow. Works on every theme.
struct KeyFace: ViewModifier {
    let base: Color
    var pressed: Bool = false
    var cornerRadius: CGFloat = 8

    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(base)
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [.white.opacity(0.22), .white.opacity(0.0)],
                                startPoint: .top,
                                endPoint: .center
                            )
                        )
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [.clear, .black.opacity(0.16)],
                                startPoint: .center,
                                endPoint: .bottom
                            )
                        )
                }
                .brightness(pressed ? 0.10 : 0)
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(Color.white.opacity(0.10), lineWidth: 0.5)
            )
            .shadow(color: .black.opacity(0.30), radius: 1.2, x: 0, y: 1)
    }
}

extension View {
    func keyFace(base: Color, pressed: Bool = false, cornerRadius: CGFloat = 8) -> some View {
        modifier(KeyFace(base: base, pressed: pressed, cornerRadius: cornerRadius))
    }
}
