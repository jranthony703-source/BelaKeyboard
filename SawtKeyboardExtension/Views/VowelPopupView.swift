import SwiftUI

/// Horizontal row of 7 vowel forms shown above a tapped consonant key.
struct VowelPopupView: View {
    let consonant: GeezConsonant
    let theme: Theme
    let onSelect: (String) -> Void
    let onDismiss: () -> Void

    var body: some View {
        HStack(spacing: 4) {
            ForEach(Array(consonant.vowelForms.enumerated()), id: \.offset) { index, form in
                Button {
                    HapticManager.tap(.light)
                    onSelect(form)
                } label: {
                    VStack(spacing: 2) {
                        Text(form)
                            .font(.system(size: 24))
                        if index < GeezConsonant.vowelLabels.count {
                            Text(GeezConsonant.vowelLabels[index])
                                .font(.system(size: 10))
                                .opacity(0.7)
                        }
                    }
                    .foregroundColor(theme.keyText)
                    .frame(minWidth: 40, minHeight: 52)
                }
                .buttonStyle(VowelButtonStyle(theme: theme))
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(theme.popupBackground.opacity(0.95))
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 3)
    }
}

private struct VowelButtonStyle: ButtonStyle {
    let theme: Theme

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                theme.popupBackground
                    .brightness(configuration.isPressed ? 0.16 : 0)
            )
            .cornerRadius(8)
            .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 2)
            .scaleEffect(configuration.isPressed ? 0.94 : 1.0)
            .animation(.easeOut(duration: 0.08), value: configuration.isPressed)
    }
}
