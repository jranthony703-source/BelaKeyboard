import SwiftUI

struct SuggestionBarView: View {
    let suggestions: [String]
    let theme: Theme
    let onSelect: (String) -> Void

    var body: some View {
        Group {
            if suggestions.isEmpty {
                placeholder
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(suggestions, id: \.self) { word in
                            SuggestionChip(word: word, theme: theme) {
                                HapticManager.tap(.light)
                                onSelect(word)
                            }
                        }
                    }
                    .padding(.horizontal, 8)
                }
            }
        }
        .frame(maxWidth: .infinity, minHeight: 42)
        .background(theme.suggestionBarBackground)
    }

    private var placeholder: some View {
        Text(" ")
            .font(.system(size: 16))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 12)
    }
}

private struct SuggestionChip: View {
    let word: String
    let theme: Theme
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Text(word)
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(theme.keyText)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
        }
        .buttonStyle(SuggestionChipStyle(theme: theme))
    }
}

private struct SuggestionChipStyle: ButtonStyle {
    let theme: Theme

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                theme.keyBackground
                    .brightness(configuration.isPressed ? 0.18 : 0)
            )
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.easeOut(duration: 0.08), value: configuration.isPressed)
    }
}
