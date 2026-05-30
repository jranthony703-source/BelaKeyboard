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
                    .background(theme.popupBackground)
                    .cornerRadius(8)
                    .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 2)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(theme.popupBackground.opacity(0.95))
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 3)
    }
}
