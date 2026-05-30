import SwiftUI

/// Standard QWERTY layout for Latin transliteration input.
struct LatinKeyboardView: View {
    let theme: Theme
    let onInsert: (String) -> Void
    let onBack: () -> Void

    @State private var isShifted = false

    private let rows = [
        ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
        ["a", "s", "d", "f", "g", "h", "j", "k", "l"],
        ["z", "x", "c", "v", "b", "n", "m"]
    ]

    var body: some View {
        VStack(spacing: 6) {
            ForEach(rows.indices, id: \.self) { rowIndex in
                HStack(spacing: 6) {
                    ForEach(rows[rowIndex], id: \.self) { key in
                        KeyButton(label: display(key), theme: theme) {
                            onInsert(display(key))
                        }
                    }
                }
            }

            HStack(spacing: 6) {
                KeyButton(label: isShifted ? "⇧" : "⇪", theme: theme, isSpecial: true) {
                    isShifted.toggle()
                }
                .frame(width: 44)
                KeyButton(label: Strings.Keyboard.geez, theme: theme, isSpecial: true, action: onBack)
                    .frame(minWidth: 60)
                Spacer()
            }
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 6)
    }

    private func display(_ key: String) -> String {
        isShifted ? key.uppercased() : key
    }
}
