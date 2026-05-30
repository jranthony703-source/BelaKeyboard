import SwiftUI

struct EmojiKeyboardView: View {
    let theme: Theme
    let onInsert: (String) -> Void

    @State private var selectedCategoryID: String = EmojiCatalog.categories.first?.id ?? "smileys"

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 8)

    private var selectedCategory: EmojiCategory {
        EmojiCatalog.categories.first { $0.id == selectedCategoryID } ?? EmojiCatalog.categories[0]
    }

    var body: some View {
        VStack(spacing: 4) {
            categoryTabs

            ScrollView {
                LazyVGrid(columns: columns, spacing: 4) {
                    ForEach(Array(selectedCategory.emojis.enumerated()), id: \.offset) { _, emoji in
                        EmojiKey(emoji: emoji, theme: theme) {
                            HapticManager.tap(.light)
                            onInsert(emoji)
                        }
                    }
                }
                .padding(.horizontal, 6)
                .padding(.vertical, 4)
            }
        }
        .background(theme.keyboardBackground)
    }

    private var categoryTabs: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 4) {
                ForEach(EmojiCatalog.categories) { category in
                    Button {
                        HapticManager.tap(.light)
                        selectedCategoryID = category.id
                    } label: {
                        Text(category.icon)
                            .font(.system(size: 20))
                            .frame(width: 40, height: 36)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(selectedCategoryID == category.id
                                          ? theme.keyText.opacity(0.18)
                                          : Color.clear)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
        }
        .frame(height: 44)
        .background(theme.suggestionBarBackground)
    }
}

private struct EmojiKey: View {
    let emoji: String
    let theme: Theme
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Text(emoji)
                .font(.system(size: 28))
                .frame(maxWidth: .infinity, minHeight: 40)
        }
        .buttonStyle(EmojiKeyStyle())
    }
}

private struct EmojiKeyStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.primary.opacity(configuration.isPressed ? 0.15 : 0))
            )
            .scaleEffect(configuration.isPressed ? 0.86 : 1.0)
            .animation(.easeOut(duration: 0.08), value: configuration.isPressed)
    }
}
