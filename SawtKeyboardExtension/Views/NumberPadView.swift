import SwiftUI

struct NumberPadView: View {
    let theme: Theme
    let onInsert: (String) -> Void
    let onBack: () -> Void

    private let numberKeys = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
    private let punctuationKeys = ["።", "፣", "፤", "፥", "፡", "?", "!", "@", "#", "$", "%", "&",
                                   "-", "_", "+", "=", "(", ")", "/", "\\", ":", ";", "\"", "'",
                                   ",", "."]

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 6), count: 8)

    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                LazyVGrid(columns: columns, spacing: 6) {
                    ForEach(numberKeys, id: \.self) { key in
                        KeyButton(label: key, theme: theme, isSpecial: false) { onInsert(key) }
                    }
                }

                LazyVGrid(columns: columns, spacing: 6) {
                    ForEach(punctuationKeys, id: \.self) { key in
                        KeyButton(label: key, theme: theme, isSpecial: false) { onInsert(key) }
                    }
                }

                HStack {
                    KeyButton(label: Strings.Keyboard.back, theme: theme, isSpecial: true, action: onBack)
                }
            }
            .padding(.horizontal, 4)
            .padding(.vertical, 6)
        }
    }
}
