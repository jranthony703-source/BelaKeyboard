import SwiftUI

struct SuggestionBarView: View {
    let suggestions: [String]
    let theme: Theme
    let onSelect: (String) -> Void

    var body: some View {
        HStack(spacing: 8) {
            if suggestions.isEmpty {
                Text(" ")
                    .font(.system(size: 16))
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                ForEach(suggestions, id: \.self) { word in
                    Button {
                        onSelect(word)
                    } label: {
                        Text(word)
                            .font(.system(size: 16))
                            .foregroundColor(theme.keyText)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(theme.keyBackground)
                            .cornerRadius(6)
                    }
                    .buttonStyle(.plain)
                }
                Spacer()
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .frame(maxWidth: .infinity, minHeight: 36)
        .background(theme.suggestionBarBackground)
    }
}
