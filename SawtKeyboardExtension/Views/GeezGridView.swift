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
            .padding(.horizontal, 4)
            .padding(.vertical, 6)
        }
        .contentShape(Rectangle())
        .onTapGesture { onBackgroundTap() }
    }
}

struct KeyButton: View {
    let label: String
    let theme: Theme
    var isHighlighted: Bool = false
    var isSpecial: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 22))
                .foregroundColor(theme.keyText)
                .frame(maxWidth: .infinity, minHeight: 44)
                .background(isSpecial ? theme.specialKeyBackground : theme.keyBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(isHighlighted ? theme.keyText.opacity(0.5) : .clear, lineWidth: 2)
                )
                .cornerRadius(6)
                .shadow(color: .black.opacity(0.15), radius: 1, x: 0, y: 1)
        }
        .buttonStyle(.plain)
    }
}
